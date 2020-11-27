#### 01. mac 修改git快捷键


```
vi ~/.zshrc


alias ga="git add"
alias gaa="git add ."
alias gst="git status"
alias gcm="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gm="git merge"
alias glg="git log --stat"
alias gd="git diff"
alias gco="git checkout"
alias grh="git reset HEAD"
alias grhh="git reset HEAD --hard"
alias gba="git branch -a"
alias gdb="git branch -d"
alias gdbo="git push origin --delete"

source ~/.zshrc
```



#### 1. 安装git后，需要设置账户名称

```
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"

#修改命令的别名
$ git config --global alias.st status
$ git config --global alias.co checkout
$ git config --global alias.ci commit
$ git config --global alias.br branch
$ git config --global alias.unstage 'reset HEAD'
#设置别名，修改status的别名为st

#移除config里的内容
git config --global --unset push.default
```
> --global参数是全局参数，也就是这些命令在这台电脑的所有Git仓库下都有用。

> 注意git config命令的--global参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。

#### 2.通过```git init```命令把这个目录变成Git可以管理的仓库
> 如果你没有看到.git目录，那是因为这个目录默认是隐藏的，用`ls -ah`命令就可以看见。

#### 3.添加git文件

```
git add file_name_1
git add file_name_2
...
git commit -m "本次修改内容的描述"
```
> 1. 使用命令git add <file>，注意，可反复多次使用，添加多个文件；
> 2. 使用命令git commit -m <message>，完成。
> 3. 如果全部为新建的文件，可以使用 ```git add .```

#### 4. git 命令

```
git status

# 命令可以让我们时刻掌握仓库当前的状态，上面的命令输出告诉我们，readme.txt被修改过了，但还没有准备提交的修改。

git diff <file name >

#顾名思义就是查看某个文件的difference, 查看文件的修改内容

git checkout -b dev 或 git switch -c dev

#创建新的分支，并切换

git branch 

#查看全部的分支

git checkout master 或 git switch master

#切换到dev分支

git merge dev

#把dev分支的修改内容合并到master分支

git branch -d dev

#删除dev分支

git log --graph

# 查看分支合并图

git push -u origin master

#由于远程库是空的，我们第一次推送master分支时，加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令。

git merge --no-ff -m "commit 的描述内容" dev

#合并分支时，加上--no-ff参数就可以用普通模式合并，合并后的历史有分支，能看出来曾经做过合并，并创建 log日志，而fast forward合并就看不出来曾经做过合并。

git remote 或 git remote -v

#要查看远程库的信息

git branch --set-upstream branch-name origin/branch-name

#建立本地分支和远程分支的关联

git rebase

#把分支提交的历史记录的分叉变成一条直线

git tag v1.0

# git tag <name> 就可以新建一个标签

git tag 

#查看所有标签
#默认标签是打在最新提交的commit上的。有时候，如果忘了打标签，比如，现在已经是周五了，但应该在周一打的标签没有打，怎么办？方法是找到历史提交的commit id，然后打上就可以了

git show <tagname>

#查看标签信息

git tag -a <tagname> -m "标签信息"
# 可以指定标签信息

git tag -d <tagname>
#删除标签

git push origin v1.0
#推送某个标签到远程

git push origin --tags
#推送全部标签到远程

git push origin :refs/tags/<tagname>
#删除已远程标签

git rm -rf --cached .
#删除本地的全部缓存

```

#### 5. commit 为保存的一个快照
> Git也是一样，每当你觉得文件修改到一定程度的时候，就可以“保存一个快照”，这个快照在Git中被称为```commit```


#### 6. git log (--pretty=oneline)查看提交日志

```
git log 

# git log命令显示从最近到最远的提交日志

commit 2df5511cf45435d558b0e421654110031a20f3cf (HEAD -> dev_a)
Author: SylorHuang <sylor_huang@126.com>
Date:   Sat Oct 12 15:30:22 2019 +0800

    xx文件的修改

commit c438a7c7c29ea76419025c5f39f7dd4cbfec7bdf (origin/dev_a)
Author: SylorHuang <sylor_huang@126.com>
Date:   Thu Oct 10 18:05:42 2019 +0800

    dddd

...

```

```
git log --pretty=oneline

#如果嫌输出信息太多，看得眼花缭乱的，可以试试加上--pretty=oneline参数

2df5511cf45435d558b0e421654110031a20f3cf (HEAD -> dev_a) xx文件的修改
c438a7c7c29ea76419025c5f39f7dd4cbfec7bdf (origin/dev_a) dddd
f9936f6c7ce298f918f001f668981eb05cdaa86f fourth commit
b52c6bff40df63e9116ca6070ae328c1e35cbe80 (origin/dev_hs, dev_hs) thitd commit
875e00a7abf127899b6da614d400cd0c7956df94 second commit
4f984d381551d1794ca52c56a40c2c9eca89acab add all_licenses
7a05f884346f5625d9f99e812fb740890e382c5d (origin/master, origin/HEAD, master) .gitignore
ae1eed46da6b4fd0945860903b091f244415398d LICENSE

```

> 上述“2df5511cf45435d558b0e421654110031a20f3cf”为```commit_id```

#### 7. git 退回到上一版本

```
git reset --hard commit_id

# commit_id没必要写全，前几位就可以了，Git会自动去找。当然也不能只写前一两位，因为Git可能会找到多个版本号，就无法确定是哪一个了。
```
> Git的版本回退速度非常快，因为Git在内部有个指向当前版本的HEAD指针，当你回退版本的时候，Git仅仅是把HEAD从指向新的

#### 8. git reflog 记录每一次的命令
> Git提供了一个命令git reflog用来记录你的每一次命令, 可以找到以前的全部记录

> 1. HEAD指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令```git reset --hard commit_id```。

> 2. 穿梭前，用```git log```可以查看提交历史，以便确定要回退到哪个版本。

> 3. 要重返未来，用`git reflog`查看命令历史，以便确定要回到未来的哪个版本。

#### 9. 工作区和版本库的名称解释 

1. 工作区：就是你在电脑里能看到的目录
2. 版本库(Repository)：工作区有一个隐藏目录```.git```，这个不算工作区，而是Git的版本库
3. Git的版本库里存了很多东西，其中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支master，以及指向master的一个指针叫HEAD。
4. ```git add```命令实际上就是把要提交的所有修改放到暂存区（Stage），然后，执行```git commit```就可以一次性把暂存区的所有修改提交到分支。
5. 工作区（work place） =>  版本库（暂存区和本地分支）
6. git add 的功能是把文件从 工作区 移动到 暂存区 
7. git commit 的功能是把文件 从暂存区 移动到 本地分支


#### 10. 撤销修改

> 场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令git checkout -- file。

> 场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD <file>，就回到了场景1，第二步按场景1操作。

> 场景3：已经提交了不合适的修改到版本库时，想要撤销本次提交，参考版本回退一节，不过前提是没有推送到远程库。

#### 11. 修改文件
> 一是确实要从版本库中删除该文件，那就用命令git rm删掉，并且git commit，文件就从版本库中被删除了。

> 另一种情况是删错了，因为版本库里还有呢，所以可以很轻松地把误删的文件恢复到最新版本
```
$ git checkout -- test.txt
```

#### 12. 修复bug时， git stash

> git stash 表示是临时存储文件。

> 修复bug时，我们会通过创建新的bug分支进行修复，然后合并，最后删除；

> 当手头工作没有完成时，先把工作现场```git stash```一下，然后去修复bug，修复后，再```git stash pop```，回到工作现场；

> 在master分支上修复的bug，想要合并到当前dev分支，可以用```git cherry-pick <commit>```命令，把bug提交的修改“复制”到当前分支，避免重复劳动。

