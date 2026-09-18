# 构建产物说明

**这个目录现在只放这份说明，导出产物统一放在仓库外。**

## 导出到哪里

```
D:\Godot\exports\02.Metroid\
```

导出预设里已配置为**单文件 exe**（PCK 已嵌入），玩家下载一个文件即可运行。

放在仓库**外面**的原因：

1. 仓库根目录保持干净，一眼能看出哪些是源码
2. 不会误提交（虽然 `.gitignore` 也拦了 `*.exe`，但这是双保险）
3. Git LFS 免费额度每月只有 1GB 流量，一个 105MB 的 exe 放在仓库里，
   别人 clone 几次就耗光了

放进 **GitHub Releases** 的二进制文件**不消耗 LFS 流量**。

## 怎么发新版本

```powershell
cd D:\Godot\Godot_source

# 1. 在 Godot 里导出到 D:\Godot\exports\02.Metroid\Metroid.exe

# 2. 打标签并推送
git tag v1.1-metroid
git push --tags

# 3. 到 GitHub 上传附件
#    https://github.com/salfzzz/godot-7-games/releases/new
```

详细的命令行上传方式见 [01.Frogger/builds/README.md](../../01.Frogger/builds/README.md)。

## 已有版本

| 版本 | 游戏 | 下载 |
|---|---|---|
| v1.0-metroid | 02. Metroid | [Releases](https://github.com/salfzzz/godot-7-games/releases/tag/v1.0-metroid) |
