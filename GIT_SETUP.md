# Git Multi-Account Setup

Guide for managing separate GitHub accounts (personal vs work) using conditional git configs and SSH keys.

## 1. Main `.gitconfig`

Create `~/.gitconfig` with conditional includes based on directory:

```gitconfig
[includeIf "gitdir/i:~/Personal/"]
    path = ~/Personal/.gitconfig

[includeIf "gitdir/i:~/dotfiles/"]
    path = ~/Personal/.gitconfig

[includeIf "gitdir/i:~/Projects/"]
    path = ~/Projects/.gitconfig
```

This automatically uses the correct identity based on where your repo is located.

## 2. Create Separate Git Configs

### Personal `~/Personal/.gitconfig`

```gitconfig
[user]
    name = Your Name
    email = your.personal@email.com
```

### Work `~/Projects/.gitconfig`

```gitconfig
[user]
    name = Your Name
    email = your.work@company.com
```

## 3. SSH Keys

Generate separate SSH keys for each account:

```bash
ssh-keygen -t rsa -f ~/.ssh/personal_id_rsa -C "personal"
ssh-keygen -t rsa -f ~/.ssh/work_id_rsa -C "work"
```

Add the public keys to respective GitHub accounts:
- `~/.ssh/personal_id_rsa.pub` → GitHub.com SSH keys
- `~/.ssh/work_id_rsa.pub` → Work GitHub Enterprise SSH keys

## 4. SSH Config

Create/edit `~/.ssh/config`:

```
# Personal GitHub
Host github.com
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/personal_id_rsa

# Work GitHub Enterprise (replace with your company's GitHub URL)
Host github.your-company.com
    HostName github.your-company.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/work_id_rsa
```

> **Note:** Replace `github.your-company.com` with your actual work GitHub Enterprise URL.

## 5. Verify Setup

Check which identity is used in a repo:

```bash
cd ~/Personal/some-repo
git config user.email  # Should show personal email

cd ~/Projects/some-repo
git config user.email  # Should show work email
```

## Directory Structure

```
~/
├── Personal/           # Personal repos → uses personal git config
│   └── .gitconfig
├── Projects/           # Work repos → uses work git config
│   └── .gitconfig
├── dotfiles/           # This repo → uses personal git config
└── .gitconfig          # Main config with conditional includes
```

