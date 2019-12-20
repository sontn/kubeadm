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
adfadf
