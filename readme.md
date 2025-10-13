# tips

## 公開されているChartをダウンロードする
```sh
$ helm search repo mongo
# NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
# stable/mongodb                          7.8.10          4.2.4           DEPRECATED NoSQL document-oriented database tha...
# stable/mongodb-replicaset               3.17.2          3.6             DEPRECATED - NoSQL document-oriented database t...
# stable/prometheus-mongodb-exporter      2.8.1           v0.10.0         DEPRECATED A Prometheus exporter for MongoDB me...
# stable/unifi                            0.10.2          5.12.35         DEPRECATED - Ubiquiti Network's Unifi Controller  

$ helm pull stable/mongodb # ダウンロード
$ tar xvzf mongodb-7.8.10.tgz # 展開
$ helm install mongo ./mongodb # インストール
```

## 公開されているチャートをパラメータを渡して実行する
```sh
mkdir testmongo
helm show values bitnami/mongodb > testmongo/values.yaml # パラメータを取得してvalues.ymlを作成
helm install my-mongodb bitnami/mongodb -f testmongo/values.yaml # パラメータを渡して実行

helm install my-mongodb bitnami/mongodb --set persistence.enabled=true # --setの場合
helm upgrade my-mongodb bitnami/mongodb --set persistence.enabled=false # 既存のhelmリソースを更新
```

## サーバー再起動時にダッシュボードに接続できない。
```sh
kubectl get all -n kubernetes-dashboard
kubectl delete deployment -n kubernetes-dashboard kubernetes-dashboard-kong
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
    --create-namespace \
    --namespace kubernetes-dashboard \
    --set kong.image.repository=kong \
    --set kong.image.tag="3.9.0"
```

`kubectl get all -n kubernetes-dashboard`で`kubernetes-dashboard-kong`が立ち上がっていないことがある。
下2行の命令で削除/再インストールすれば復旧する。
[kong:3.9に関する参考](https://github.com/kubernetes/dashboard/issues/9955)

```sh
# その他関連コマンド
# Kong Podのログを確認
kubectl logs -n kubernetes-dashboard kubernetes-dashboard-kong-648658d45f-n4nc7

# Kong Podの詳細情報を確認
kubectl describe pod -n kubernetes-dashboard kubernetes-dashboard-kong-648658d45f-n4nc7
```

## k8sでローカルのdocker.registryを立てたときの各種エラー
### dockerでpush/pullできない。
```sh
$ docker push <hostname>:5000/busybox:1.36.1
The push refers to repository [<hostname>:5000/busybox]
Get "https://<hostname>:5000/v2/": http: server gave HTTP response to HTTPS client
```

httpsを想定しているのにhttpのレスポンスが返ってきた旨のエラー
以下の通りエラー回避

```sh
sudo nano /etc/docker/daemon.json

# /etc/docker/daemon.json
{
  "insecure-registries": ["<hostname>:5000"]
}

sudo systemctl reload docker
```
この操作は対象のレジストリにpush/pullしたいすべての端末で行う

[Docker のプライベートレジストリを構築し Kubernetes から利用する | qiita](https://qiita.com/tkarube/items/d3c008cc0dc9d139f819)

## k8sのノードでpullできない。
```sh
Failed to pull image "<hostname>:5000/toolbox": failed to pull and unpack image "<hostname>:5000/toolbox:latest": failed to resolve referenc ││ e "<hostname>:5000/toolbox:latest": failed to do request: Head "https://<hostname>:5000/v2/toolbox/manifests/latest": http: server gave HTTP response to HTTPS client
```

k8sではdockerがコンテナイメージをpullしているわけではない。
例えばコンテナランタイムにcontainerdを採用している場合は以下の通りエラー回避する。

```sh
sudo nano /etc/containerd/config.toml

# /etc/containerd/config.toml
# (中略)
      [plugins."io.containerd.grpc.v1.cri".registry.configs]
        [plugins."io.containerd.grpc.v1.cri".registry.configs."<hostname>:5000".tls]
          insecure_skip_verify = true

      [plugins."io.containerd.grpc.v1.cri".registry.headers]

      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."<hostname>:5000"]
          endpoint = ["http://<hostname>:5000"]
# (中略)
```
