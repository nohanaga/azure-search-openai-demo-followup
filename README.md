# ChatGPT + Enterprise data with Azure OpenAI and Cognitive Search
## 日本語カスタマイズ版

このサンプルでは、Retrieval Augmented Generation パターンを使用して、独自のデータに対してChatGPT のような体験を作成するためのいくつかのアプローチを示しています。ChatGPT モデル（gpt-35-turbo）にアクセスするために Azure OpenAI Service を使用し、データのインデックス作成と検索に Azure Cognitive Search を使用しています。

レポジトリにはサンプルデータが含まれているので、すぐに End-to-End で試すことができます。このサンプルアプリケーションでは、日本の鎌倉時代の武将に関する Wikipedia データが含まれており、鎌倉幕府や武将について質問できるような体験ができます。

![RAG Architecture](docs/appcomponents.png)

## 機能

* チャット、Q&A インターフェース
* 引用、ソースコンテンツの追跡など、ユーザが回答の信頼性を評価するための様々な選択肢を検討する。
* データ準備、プロンプト作成、モデル（ChatGPT）と Retriever(Azure Cognitive Search) 間の連携のための可能なアプローチを示すことができる。
* UX で直接設定することで、動作の調整やオプションの実験が可能です。

![Chat screen](docs/chatscreen.png)

## Getting Started 日本語カスタマイズ版構築手順

> **重要:** このサンプルをデプロイして実行するには、 **Azure OpenAI Service へのアクセスを有効にした** Azure サブスクリプションが必要です。アクセスは[こちら](https://aka.ms/oaiapply)からリクエストできます。

### 前提条件

- Azure Developer CLI (install from [here](https://aka.ms/azure-dev/install))
- Python 3.10 系 (install from [here](https://www.python.org/downloads/))
    - **重要**: Python とpip パッケージマネージャは、セットアップスクリプトを動作させるために、Windows のパスに含まれている必要があります。
    - Anaconda で仮想環境を作ることをお勧めします。`conda create -n py310 python=3.10 anaconda`
- Node.js v18.13.0 動作確認済 (install from [here](https://nodejs.org/en/download/))
- Git (install from [here](https://git-scm.com/downloads))
- Powershell (pwsh) (install from [here](https://github.com/powershell/powershell))
   - **重要**: PowerShell コマンドから pwsh.exe を実行できることを確認する。失敗した場合は、PowerShell のアップグレードが必要な可能性があります。

### インストール

1. このレポジトリをダウンロードするか、`git clone` して `/azure-search-openai-demo` に移動します。
1. PowerShell を起動して、Azure にログインします。さらにデフォルトのサブスクリプションをセットしておきます。
    ```ps
    az login
    az account set --subscription [Your Subscription ID]
    ```
1. 以下を実行し、自分の Azure AD のオブジェクト ID を控えておきます。
    ```ps
    az ad signed-in-user show --query id --out tsv
    ```
1. 以下の Azure Developer CLI コマンドで環境を作成し、自動デプロイを開始します。
    ```ps
    azd up
    ```
    以下の 3 つの質問に答えてください。Initializing a new project (azd init)
    ```
    ? Please enter a new environment name: 任意の環境名
    ? Please select an Azure Subscription to use: 自分のサブスクリプション名
    ? Please select an Azure location to use: デプロイ先リージョン(East US 推奨)
    ```

    - **重要**: 本サンプルで使用しているモデルを現在サポートしているリージョンは、米国東部(East US)または米国南中部(South Central US)です。最新のリージョン・モデル一覧は[こちら](https://learn.microsoft.com/azure/cognitive-services/openai/concepts/models)をご確認ください。
1. **Creating/Updating resources** が表示されたら <kbd>Ctrl</kbd> + <kbd>C</kbd> を押下して、実行を中断します。
1. ディレクトリに生成された `.azure/環境名/.env` の `AZURE_PRINCIPAL_ID` の値を、事前に控えておいた自分のオブジェクト ID に書き換えて、再び `azd up` コマンドを実行します。※ここは公式のサンプルでバグ修正中です。
1. 以下のリソースがデプロイ完了するまでしばらく待ちます。結構時間がかかります。
    ```
    (✓) Done: Resource group: rg-環境名
    (✓) Done: App Service plan: plan-random123
    (✓) Done: Storage account: strandom123
    (✓) Done: App Service: app-backend-random123
    ```

ローカルで実行:
* `./app/start.cmd` を実行するか、"VS Code Task: Start App" を実行し、プロジェクトをローカルに起動します。

- **重要**: **デフォルトでは、このサンプルは Azure App Service に誰でもアクセスできる Web サービスとしてデプロイされます。デモデータだけならそれでよいですが、秘密情報が入ったファイルを使用しないようにしてください。情報漏洩のリスクがあります。Web サービスを使用せず、ローカル環境のみで使用する場合、App Service を停止もしくは削除してください。**

- **重要**: **AZURE RESOURCE COSTS** デフォルトでは、このサンプルは月額費用が発生する Azure App Service と Azure Cognitive Search リソースを作成します。このコストを回避したい場合は、infra フォルダ下のパラメータファイルを変更することで、それぞれを無料版に切り替えることができます (ただし、考慮すべき制限があります。たとえば、無料の Cognitive Search リソースは、1 つのサブスクリプションにつき最大 1 つまでです)。

### Quickstart

* Azureの場合：azd によってデプロイされた Azure WebApp を開いてください。URL はazd の完了時に出力される（「Endpoint」として）か、Azure ポータルで確認することができます。このリソースが不要であれば、停止や削除ができます。
* ローカルで実行: ブラウザで 127.0.0.1:5000 を開きます。

ウェブアプリでは、
* チャットや Q&A のコンテキストで、さまざまなトピックを試してみましょう。チャットでは、フォローアップの質問、明確化、回答の簡略化または詳細化を求めるなど、さまざまなことを試してみてください。
* 引用とソースの探索
* 「設定」をクリックすると、さまざまなオプションを試したり、プロンプトを調整したりすることができます。


## Resources

* [Revolutionize your Enterprise Data with ChatGPT: Next-gen Apps w/ Azure OpenAI and Cognitive Search](https://aka.ms/entgptsearchblog)
* [Azure Cognitive Search](https://learn.microsoft.com/azure/search/search-what-is-azure-search)
* [Azure OpenAI Service](https://learn.microsoft.com/azure/cognitive-services/openai/overview)

### Note
>Note: The PDF documents used in this demo contain information generated using a language model (Azure OpenAI Service). The information contained in these documents is only for demonstration purposes and does not reflect the opinions or beliefs of Microsoft. Microsoft makes no representations or warranties of any kind, express or implied, about the completeness, accuracy, reliability, suitability or availability with respect to the information contained in this document. All rights reserved to Microsoft.
