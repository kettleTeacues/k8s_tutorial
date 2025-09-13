# tips
## サーバー再起動時にダッシュボードに接続できない。
```sh
kubectl get all -n kubernetes-dashboard
kubectl delete deployment -n kubernetes-dashboard kubernetes-dashboard-kong
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

`kubectl get all -n kubernetes-dashboard`で`kubernetes-dashboard-kong`が立ち上がっていないことがある。
下2行の命令で削除/再インストールすれば復旧する。

```sh
# その他関連コマンド
# Kong Podのログを確認
kubectl logs -n kubernetes-dashboard kubernetes-dashboard-kong-648658d45f-n4nc7

# Kong Podの詳細情報を確認
kubectl describe pod -n kubernetes-dashboard kubernetes-dashboard-kong-648658d45f-n4nc7
```
