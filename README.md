# Get Started:
```
git clone https://github.com/Ritzier/dotfiles $HOME
```

## Git SSH
git config --global user.name "YourName"
git config --global user.email "YourEmail@example.com"
ssh-keygen -t rsa -b 4096 -C "YourEmail@example.com"
### Add `cat  $HOME/.ssh/id_rsa.pub` to Github [here](https://link.zhihu.com/?target=https%3A//github.com/settings/keys)
### Test your SSH connection:
```
ssh -T git@github.com
```
