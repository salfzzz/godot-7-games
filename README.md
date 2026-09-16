# Godot 7 个小游戏 — 开发学习记录

这是我学习 Godot 4 游戏开发的过程记录仓库。跟着课程从零开始，完成 7 个小游戏，
每个游戏一个独立文件夹，用 Git 提交历史记录我的真实开发轨迹。

## 项目进度

| 序号 | 项目 | 类型 | 状态 |
|:---:|---|---|---|
| 01 | [Frogger](01.Frogger/) | 2D 过马路 | ✅ 已完成（可执行版见 Releases） |
| 02 | [Metroid](02.Metroid/) | 2D 平台射击 | 🚧 待开始 |
| 03 | [Farming](03.Farming/) | 2D 农场经营 | ⬜ 未开始 |
| 04 | [Monster](04.Monster/) | 回合制战斗 | ⬜ 未开始 |
| 05 | [Space](05.Space/) | 3D 太空射击 | ⬜ 未开始 |
| 06 | [3DPlatformer](06.3DPlatformer/) | 3D 平台跳跃 | ⬜ 未开始 |
| 07 | [Shooter](07.Shooter/) | 3D 第一人称射击 | ⬜ 未开始 |

## 仓库结构

```
.
├── 01.Frogger/          第一个完成的游戏
├── 02.Metroid/          ← 后续 6 个游戏，每个文件夹放一个独立 Godot 项目
├── 03.Farming/             把你的 project.godot 直接放在对应文件夹根目录即可
├── 04.Monster/
├── 05.Space/
├── 06.3DPlatformer/
└── 07.Shooter/
```

每个游戏文件夹里就是一个完整的 Godot 项目，用 Godot 4 打开其中的 `project.godot` 即可编辑。

## 环境

- Godot 4.x
- Git + Git LFS

## 大文件说明（Git LFS）

导出的可执行文件和压缩包超过 GitHub 的 100MB 单文件上限，用 **Git LFS** 管理：

```bash
git lfs install      # 每台机器只需一次
git clone <仓库地址>  # 克隆时会自动拉取 LFS 文件
```

`01.Frogger` 的 Windows 可执行版通过
[Releases](../../releases) 分发，这样仓库本身保持轻量。

## 关于课程素材

本仓库**只包含我自己编写和导出的内容**。

学习所用的付费课程资料（含讲师提供的起始项目、成品工程、美术音效素材）
属于原作者版权，**未包含在本仓库中**，仅作为本地参考资料使用，
已通过 `.gitignore` 排除。仓库中的每个项目都是我自己跟着课程动手实践的成果。

## 提交记录约定

为了让 Git 历史真实反映学习过程，我按下面的方式提交：

```bash
git add 02.Metroid
git commit -m "feat(metroid): 完成角色基础移动"
```

类型前缀：`feat` 新功能 / `fix` 修 bug / `docs` 笔记 / `chore` 杂项

## 学习笔记

每个项目文件夹里的 `NOTES.md` 记录我在这个项目中学到的 Godot 知识点和踩过的坑。
