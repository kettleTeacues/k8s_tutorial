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
