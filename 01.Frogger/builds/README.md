# 构建产物说明

**这个目录现在只放这份说明，导出产物统一放在仓库外。**

## 导出到哪里

```
D:\Godot\exports\
├── 01.Frogger\
└── 02.Metroid\
```

放在仓库**外面**的原因：

1. 仓库根目录保持干净，一眼能看出哪些是源码
2. 不会误提交（虽然 `.gitignore` 也拦了 `*.exe`，但这是双保险）
3. Git LFS 免费额度每月只有 1GB 流量，一个 105MB 的 exe 放在仓库里，
   别人 clone 几次就耗光了

放进 **GitHub Releases** 的二进制文件**不消耗 LFS 流量**，而且有独立的下载页面。

## 怎么发新版本

### 1. 在 Godot 里导出

项目 → 导出 → 选 "Windows Desktop" → 导出到 `D:\Godot\exports\<项目名>\`。

> 建议在导出预设里勾上 **Embed PCK**（`binary_format/embed_pck`），
> 这样只生成一个 exe，玩家下载一个文件就能玩。
> 不勾的话会分离出 exe + pck，两个文件都得下载。

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

### 4. 或者用命令上传（需要 PAT）

如果你有 Personal Access Token，可以这样：

```powershell
$token = "你的_token"
$tag   = "v1.1-frogger"
$file  = "D:\Godot\exports\01.Frogger\CrossRoad.exe"
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
| v1.0-metroid | 02. Metroid | [Releases](https://github.com/salfzzz/godot-7-games/releases/tag/v1.0-metroid) |
