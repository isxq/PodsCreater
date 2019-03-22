# PodsCreater
PodCreater 能方便快速的生成 pod 库，适用于项目组件化管理。
## 使用方法

### 准备
1. 新建 repo，作为私有 pod 源仓库
2. `pod repo add [私有仓库名] [目标 repo 地址]`
3. 创立文件夹，例如 `Project`，把主工程文件放到该文件夹下
4. 将本脚本也放在 `Project` 文件夹下
5. 将 `template` 文件夹下的 `Podfile` 中的 `source 'https://github.com/isxq/PrivatePodsRepo.git'` 换成第一步中自己的仓库地址
6. 将 `template` 文件夹下的 `upload.sh` 中的 `xqrepo` 改成第二步中自己的私有仓库名

目录结构应如下

```
Project
├── PodsCreater
└── MainProject
```
### 抽离

1. 新建 Xcode 工程 `SubProjec` ，放到 `Project` 下
2. 新建同名 repo（建好之后网页不要关闭）

目录结构为：

```
Project
├── PodsCreater
├── MainProject
└── SubProject
```

进入 `PodsCreater` 文件夹下，执行

```bash
./config.sh
```
脚本会要求输入一些信息：
    - `ProjectName`：SubProject
    - `HTTPS Repo`，`SSH Repo`， `Home Page URL`：从网页获取

执行完毕之后 `SubProject` 工程的 `SubProject` 文件夹下会再生成一个 `SubProject` 文件夹，结构如下：

```
SubProject
├── SubProject
│   ├── SubProject
│   │   └── （To Write your Code）
│   ├── SubProject.h
│   └── info.pilist
├── Podfile  
├── upload.sh  
├── readme.md
├── FILE_LINCENS
├── SubProject.podspec
└── SubProject.xcodeproj
```

（这里创建的工程是 framework，生成正常的 app 也是可以的，根据自己的需求选择。）
打开工程将 `SubProject` 文件夹添加到 `SubProject` 工程中，以便添加文件及开发，在该文件夹下的代码会被发布到生成的 Pod 库中。

### 依赖和调用

假如该部分组件依赖其他组件，需要在 `Podfile` 中添加相关的组件，并在 `.podspec` 文件中通过 `s.dependency "xxx"` 进行标明。

开发过程中，`MainProject` 引用本地 pod 库的方式是在 `MainProject/Podfile` 中添加 pod 依赖，添加方式如下：

```
    pod 'SubProject', :path => '../SubProject'
```

本地其他组件之间的调用方式同上。

### 发布

组件的发布是将本地组件发布到我们刚才为每个组件创建的线上 Repo 中。

进入到组件目录下，先提交修改以及打上标签：

```
git add .
git commit -m "描述"
git tag 版本号
```
注意。这里的版本号需要和 `.podspec` 文件中的 `s.version`一致。
提交

```
git push origin master --tags
```
如果是第一次提交有可能会报错（远程 Repo master 不存在）
执行

```
git pull
git push --force origin master --tags
```
就可以提交上了。
此时进行版本发布，执行

```
./upload.sh
```

等到成功以后，将引用该组件的工程的 `Podfile` 里的本地引用改为正常引用（将后边的 `: path...` 去掉）就可以了。
