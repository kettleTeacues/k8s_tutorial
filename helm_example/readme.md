# 事実上の標準ツールとなっているKubernetes向けデプロイツール「Helm」入門
公開日2020-03-05
https://knowledge.sakura.ad.jp/23603/

# 新たなChartを作成する
## helmコマンドでChartのひな形を作成する
helmコマンドでは、Chartを新規に作成するためのひな形を作成する「helm create ＜Chart名＞」コマンドが用意されている。まずはこのコマンドを使ってChartに必要なファイルを生成すると良い。

次の例は、「example」というChart名を指定して「helm create」コマンドを実行したものだ。このコマンドを実行するとChart名と同一のディレクトリが作成され、そこにChartとして利用するために最低限必要なファイルが作成される。
```sh
$ helm create example
Creating example

$ ls -R example/
example/:
Chart.yaml  charts  templates  values.yaml

example/charts:

example/templates:
NOTES.txt  _helpers.tpl  deployment.yaml  ingress.yaml  service.yaml  serviceaccount.yaml  tests

example/templates/tests:
test-connection.yaml
```
ここでは基本的な設定ファイルやテンプレートに加えて、templates/_helpers.tplといったヘルパーファイルや、テストを記述するtemplates/test/test-connection.yamlといったファイルも作成されていることが分かる。

「helm create」コマンドで作成されたChartには必要な最低限の設定がすべて記述されており、デフォルトではnginxのコンテナイメージをデプロイするよう指定されている。そのため、特に手を加えなくても次のようにインストールが可能だ。

これらを踏まえ、実際に独自のChartを作成する際には次のような手順で設定ファイルの修正を行っていけば良い。

1. Chart.yamlファイルを編集し、Chartの基本的な情報やappVersionを指定する
2. values.yamlファイルを編集し、使用するコンテナイメージファイルやServiceに割り当てるポート番号、ServiceAccountおよびIngressを作成するかどうかを指定する
3. templates/deployment.yamlを編集し、作成するPodのパラメータなどを変更する
4. templates.service.yamlを編集し、使用するポートなどの情報を変更する
5. 必要に応じてserviceaccount.yamlやingress.yamlを編集してパラメータや設定を変更する

# helmで自作チャートを作成する
2022/08/07に公開
https://zenn.dev/sugasuga/articles/6dfee641f77cf8
