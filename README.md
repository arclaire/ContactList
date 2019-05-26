# ContactList

repo link : https://github.com/arclaire/ContactList

Admins-MacBook-Pro:myContactList user$ git status
On branch master
Your branch is ahead of 'origin/master' by 2 commits.
(use "git push" to publish your local commits)

Changes not staged for commit:
(use "git add/rm <file>..." to update what will be committed)
(use "git checkout -- <file>..." to discard changes in working directory)

deleted:    myContactList/Assets.xcassets/AppIcon.appiconset/Contents.json
deleted:    myContactList/Assets.xcassets/Contents.json
deleted:    myContactList/Base.lproj/LaunchScreen.storyboard
deleted:    myContactList/Base.lproj/Main.storyboard
deleted:    myContactList/ViewController.swift

Untracked files:
(use "git add <file>..." to include in what will be committed)

myContactList/API/
myContactList/Categories/
myContactList/Model/
myContactList/Resources/Assets.xcassets/AppIcon.appiconset/
myContactList/Resources/Base.lproj/
myContactList/View/

no changes added to commit (use "git add" and/or "git commit -a")
Admins-MacBook-Pro:myContactList user$ git remote add origin https://github.com/arclaire/ContactList.git
fatal: remote origin already exists.
Admins-MacBook-Pro:myContactList user$ git push -u origin master
remote: Repository not found.
fatal: repository 'https://github.com/arclaire/myContactList.git/' not found
Admins-MacBook-Pro:myContactList user$ git init
Reinitialized existing Git repository in /Users/user/Desktop/myPlayground/myContactList/.git/
Admins-MacBook-Pro:myContactList user$ git remote add origin https://github.com/arclaire/ContactList.git
fatal: remote origin already exists.
Admins-MacBook-Pro:myContactList user$ remote set-url origin https://github.com/arclaire/ContactList.git
-bash: remote: command not found
Admins-MacBook-Pro:myContactList user$ git remote set-url origin https://github.com/arclaire/ContactList.git
Admins-MacBook-Pro:myContactList user$ git log
commit 5aafbcf4a2dd7370218b9f93e6c8a0d4dfcadf95 (HEAD -> master)
commit 5aafbcf4a2dd7370218b9f93e6c8a0d4dfcadf95 (HEAD -> master)
commit 5aafbcf4a2dd7370218b9f93e6c8a0d4dfcadf95 (HEAD -> master)
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 26 23:49:21 2019 +0700

remove space

commit c6c0a0faefd649dd8306ec8c56f71fd523031c1e (origin/master)
Author: arclaire <yuki_lcy@yahoo.com>
Date:   Sun May 26 23:49:01 2019 +0700

Create README.md

commit ae95c553044fe3687d48ba37d2dee15a0ecb641f
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 26 23:43:06 2019 +0700

fix error and view ui

commit bde1d0bb95ceffb4bbe30160488b9262472baeb0
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 26 23:25:02 2019 +0700

added textview

commit b4b7a7307d7df598a86905fb020b3601fb0915e6
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 26 23:24:20 2019 +0700

added edit and add new

commit 70a3917d7209627152336d678f52aed09956e932
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 26 23:11:09 2019 +0700

new view

commit 4b82c83dbf77375b3892205301fe8129e1b04fc4
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 26 17:27:46 2019 +0700

first commit

commit 3535cb52b39e7b41df9a128a77a515cc57a06ba0
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 12 15:33:53 2019 +0700

added service

commit de4151ae94c848e8e10f7b33b50e392ab6edbbe6
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 12 12:50:45 2019 +0700

initial commit

commit 4c6c6ca1b143298d3cdee57ae239a5c209c1ae8c
Author: lucy <yuki_lcy@yahoo.com>
Date:   Sun May 12 02:04:15 2019 +0700

Initial Commit
