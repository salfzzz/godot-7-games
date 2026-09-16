# 构建产物说明

**这个目录里的 exe 不会进 Git 仓库**，已由 `.gitignore` 排除。

## 为什么

Git LFS 免费额度每月只有 1GB 流量。一个 105MB 的 exe 如果放在仓库里，
每次有人 clone 都会消耗 105MB 额度，同一个人拉两次就没了。

放进 **GitHub Releases** 的二进制文件**不消耗 LFS 流量**，而且有独立的下载页面。

## 怎么发新版本

### 1. 在 Godot 里导出

项目 → 导出 → 选 "Windows Desktop" → 导出到本目录。

### 2. 打标签并推送

```powershell
cd D:\Godot\Godot_source
git tag v1.1-frogger
git push --tags
```

### 3. 上传到 Releases

打开 https://github.com/salfzzz/godot-7-games/releases/new

- 选择刚推的标签
- 填写标题，例如 `01. Frogger v1.1`
- 把 exe 拖进附件区域
- 发布

### 4. 或者用一行命令上传（需要 PAT）

如果你有 Personal Access Token，可以这样：

```powershell
$token = "你的_token"
$tag   = "v1.1-frogger"
$file  = "01.Frogger\builds\windows\CrossRoad.exe"
$repo  = "salfzzz/godot-7-games"

$h = @{ Authorization = "Bearer $token"; "User-Agent" = "dsh" }
$rel = Invoke-RestMethod "https://api.github.com/repos/$repo/releases" -Method Post `
  -Headers $h -ContentType "application/json" `
  -Body (@{ tag_name = $tag; name = $tag } | ConvertTo-Json)

$bytes = [IO.File]::ReadAllBytes((Resolve-Path $file))
Invoke-RestMethod "$($rel.upload_url)?name=$(Split-Path $file -Leaf)" -Method Post `
  -Headers $h -Body $bytes -ContentType "application/octet-stream"
```

## 已有版本

| 版本 | 游戏 | 下载 |
|---|---|---|
| v1.0-frogger | 01. Frogger | [Releases](https://github.com/salfzzz/godot-7-games/releases/tag/v1.0-frogger) |
