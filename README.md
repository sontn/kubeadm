# Cài đăt kubernetes (k8s) HA bằng kubeadm cho môi trường sản phẩm thật

Để quản trị với K8s, việc đầu tiên chúng ta phải cài đặt được K8s lên. Có nhiều cách để làm, một trong những cách đơn giản để làm là sử dụng công cụ kubeadm. Công cụ này là production-ready, nghĩa là sử dụng trong quá trình cài đặt cho môi trường chạy sản phẩm thật.

## 1. Mô hình triển khai
01 load balancer làm nhiều vụ load balance cho các máy chủ master của k8s

03 máy chủ master (controller). 03 master để đảm bảo môi trường HA cho master

03 máy chủ worker (node). 03 worker để ứng dụng có thể chạy phân tải


![k8s models](https://raw.githubusercontent.com/sontn/kubeadm/master/images/k8s_models.PNG)

**Cấu hình phần cứng**

**OS**: Ubuntu 16.04 TLS

**Resource**:  n1-standard-n2 với các master node, n1-standard-n1 với các worker node và g1-small cho load balancer

**IP**: Private IP

## 2. Triển khai
### 2.1. Tạo máy chủ bằng Terraform

Các máy này được chạy trên môi trường Google Cloud Platform. Chúng ta có thể sử dụng Terraform để tạo ra máy ảo cho nhanh theo cách Infrastructure as Code.
Code tạo máy ảo chi tiết chúng ta có thể xem tại đây:

Terraform có 3 bước chính để chạy

```
terraform init
terraform plan
terraform apply
```

### 2.2. Cài đặt K8s HA
#### Cài đặt các gói liên quan docker, kubeadm, kubelet, kubectl
Truy cập ssh vào 06 máy ảo master và node, bằng câu lệnh mẫu như sau
`gcloud compute ssh master01`

và cài đặt tất cả gói sau trên 06 máy
```
{
sudo apt-get update && apt-get install curl apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install docker-ce kubelet kubeadm kubectl -y
}
```

#### Cài đặt và cấu hình Load balancer bằng nginx
Vì có 03 máy master nên chúng ta cần một load balancer để phân tải vào 03 máy master này. Chúng ta sẽ sử dụng Nginx để làm load balancer trong bài viết này.

Ssh vào lb01:

`gcloud compute ssh lb01`

Cài đặt nginx
```
{
sudo apt-get install -y nginx
sudo systemctl enable nginx
}
```
Tiếp theo tạo file cấu hình nginx
```
{
sudo mkdir -p /etc/nginx/tcpconf.d
sudo vi /etc/nginx/nginx.conf
}
```
Thêm dòng này vào cuối file nginx.conf
`include /etc/nginx/tcpconf.d/*;`
Giờ chúng ta lấy địa chỉ IP Private (không cần sử dụng IP  Public) của 03 máy master, chúng ta có thể sử dụng câu lệnh ở dưới, được chạy trên máy làm việc (laptop/desktop) để lấy ra thông tin IP Private:
`gcloud compute instances list | grep master`
Chúng ta chạy lệnh này để cấu hình load balancer của nginx cho 03 máy master
```
cat << EOF | sudo tee /etc/nginx/tcpconf.d/kubernetes.conf
stream {
    upstream kubernetes {
        server 10.140.0.56:6443;
        server 10.140.0.52:6443;
        server 10.140.0.54:6443;
    }
server {
        listen 6443;
        listen 443;
        proxy_pass kubernetes;
    }
}
EOF
```
Load lại file cấu hình của nginx
`sudo nginx -s reload`
Thử kiểm tra load balancer đã hoạt động tốt chưa bằng câu lệnh
`nc -v 10.140.0.59 443`
trong đó 10.140.0.59 là địa chỉ IP Private của Load Balancer.
Nếu chúng ta thấy output là Succeed tức là đã thành công, load balancer nginx đã forward được request vào các máy master.
### 2.3. Cấu hình các master node
#### Chọn một master node đầu tiên để khởi tạo
Chúng ta chọn luôn master node có tên là master01 để khởi tạo cụm master node.
Câu lệnh như sau:
`sudo kubeadm init - control-plane-endpoint "10.140.0.59:6443" - upload-certs`
Trong đó 10.140.0.59 là IP Private của Load Balancer Nginx.
Output sẽ dạng như sau:
```
...
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/
You can now join any number of the control-plane node running the following command on each as root:
kubeadm join 10.140.0.59:6443 --token 7kay49.506yr6xrnbyxxxxx \
    --discovery-token-ca-cert-hash sha256:96a61d3463af4a31d4f97681f43dcf85adb0b73f889a01c8fc4a831bcedxxxxx \
    --control-plane --certificate-key 155faf6ee07c34310b27f7a62d708731e5e5072a176e3fc6169cf14xxxxxx
Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.
Then you can join any number of worker nodes by running the following on each as root:
kubeadm join 10.140.0.59:6443 --token 7kay49.506yr6xrnbyjgku3 \
    --discovery-token-ca-cert-hash sha256:96a61d3463af4a31d4f97681f43dcf85adb0b73f889a01c8fc4a831bxxxxx
```
Note: Lưu thông tin thật kỹ để sử dụng join các master và worker node vào cụm cluster
Như vậy tức bước khởi tạo master node đầu tiên đã thành công.
Giờ cấu hình để làm việc được với kubectl. Chúng ta chạy kubectl ngay trên master01. Câu lệnh như sau:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
#### Cài đặt network cho k8s
Chạy lệnh này trên máy master01
`kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"`
Output
```
serviceaccount/weave-net created 
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created daemonset.apps/weave-net created
```
Kiểm tra lại xem đã thực sự chạy chưa, chúng ta sử dụng câu lệnh
`kubectl get pod -n kube-system`
Nếu output như ở dưới thì quá trình cài đặt network và master đã chạy tốt.
```
NAME                                     READY   STATUS    RESTARTS   AGE
coredns-6955765f44-4n2ms                 1/1     Running   0          6m20s
coredns-6955765f44-5pd8r                 1/1     Running   0          6m20s
etcd-master01                            1/1     Running   0          6m26s
kube-apiserver-master01                  1/1     Running   0          6m26s
kube-controller-manager-master01         1/1     Running   0          6m26s
kube-proxy-k59hx                         1/1     Running   0          6m20s
kube-scheduler-master01                  1/1     Running   0          6m26s
weave-net-lh6hb                          2/2     Running   0          39s
```
#### Cài đặt 02 master node còn lại
Ssh vào từng máy master còn lại để chạy câu lệnh ở dưới:
```
sudo kubeadm join 10.140.0.59:6443 --token 7kay49.506yr6xrnbyxxxxx \
--discovery-token-ca-cert-hash sha256:96a61d3463af4a31d4f97681f43dcf85adb0b73f889a01c8fc4a831bcedxxxxx \
    --control-plane --certificate-key 155faf6ee07c34310b27f7a62d708731e5e5072a176e3fc6169cf14040xxxxx
```
