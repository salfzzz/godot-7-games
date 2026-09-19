# Godot 7 个小游戏 — 开发学习记录

这是我学习 Godot 4 游戏开发的过程记录仓库。跟着课程从零开始，完成 7 个小游戏，
每个游戏一个独立文件夹，用 Git 提交历史记录我的真实开发轨迹。

## 项目进度

| 序号 | 项目 | 类型 | 状态 |
|:---:|---|---|---|
| 01 | [Frogger](01.Frogger/) | 2D 过马路 | ✅ 已完成（[可执行版](https://github.com/salfzzz/godot-7-games/releases/tag/v1.0-frogger)） |
| 02 | [Metroid](02.Metroid/) | 2D 平台射击 | ✅ 已完成（[可执行版](https://github.com/salfzzz/godot-7-games/releases/tag/v1.0-metroid)） |
| 03 | [Farming](03.Farming/) | 2D 农场经营 | 🚧 进行中（初始工程已导入） |
| 04 | [Monster](04.Monster/) | 回合制战斗 | ⬜ 未开始 |
| 05 | [Space](05.Space/) | 3D 太空射击 | ⬜ 未开始 |
| 06 | [3DPlatformer](06.3DPlatformer/) | 3D 平台跳跃 | ⬜ 未开始 |
| 07 | [Shooter](07.Shooter/) | 3D 第一人称射击 | ⬜ 未开始 |

## 仓库结构

```
.
├── 01.Frogger/          第一个完成的游戏
├── 02.Metroid/          ← 当前进行中
├── 03.Farming/          每个文件夹一个独立 Godot 项目
├── 04.Monster/          用 Godot 打开其中的 project.godot 即可编辑
├── 05.Space/
├── 06.3DPlatformer/
└── 07.Shooter/
```

导出的可执行文件不进仓库，统一放在
[Releases](https://github.com/salfzzz/godot-7-games/releases) 页面。

每个游戏文件夹里就是一个完整的 Godot 项目，用 Godot 4 打开其中的 `project.godot` 即可编辑。

## 环境

- Godot 4.7.2（课程录制用 4.4，4.x 向下兼容）
- Git + Git LFS

## 大文件说明

**导出的可执行文件不进仓库**，统一放在 [Releases](../../releases) 页面。

这么做是因为 Git LFS 免费额度每月只有 1GB 流量，一个 105MB 的 exe
被 clone 几次就耗光了。Releases 附件不消耗 LFS 流量。

仓库内部仍用 **Git LFS** 管理音频、字体、3D 模型等素材：

```bash
git lfs install      # 每台机器只需一次
git clone <仓库地址>  # 克隆时会自动拉取 LFS 文件
```

发布新版本的流程见 [01.Frogger/builds/README.md](01.Frogger/builds/README.md)。

## 关于课程素材

学习所用的付费课程资料（讲师的起始项目、各阶段成品工程、美术音效素材）
属于原作者版权，**未包含在本仓库中**，仅作为本地参考资料使用，
已通过 `.gitignore` 排除（`*课程资料*/` 规则）。

需要说明的是：本仓库中的项目**是跟随该课程逐步实践完成的**，
其中 01.Frogger 与 02.Metroid 的**初始素材和部分工程配置来自课程提供**，
游戏逻辑代码由我跟随课程逐步编写。各项目 README 里有具体标注。
这属于个人学习记录用途，不代表独立原创作品。

## 提交记录约定

为了让 Git 历史真实反映学习过程，我用仓库根目录的 `push.ps1` 逐步提交：

```powershell
cd D:\Godot\Godot_source
.\push.ps1 "完成角色基础移动" -Project 02.Metroid
```

它会自动补上 `feat(02.metroid):` 前缀、检查课程资料有没有误入暂存区、然后推送。

类型前缀：`feat` 新功能 / `fix` 修 bug / `docs` 笔记 / `chore` 杂项

## 学习笔记

每个项目文件夹里的 `NOTES.md` 记录我在这个项目中的开发日志，
`README.md` 里有该项目的进度勾选清单。
