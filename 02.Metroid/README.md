# 02. Metroid — 横版闯关

**状态：** 🚧 进行中

2D 横版平台射击，含子弹、动画、TileMap、光照与 Shader。

## 文件夹结构

```
02.Metroid/
├── README.md          本说明
├── project.godot      Godot 项目本体（用 Godot 4.4 打开这一层）
├── audio/             音效素材
└── graphics/          美术素材
```

## 怎么打开

用 **Godot 4.4** 打开本文件夹里的 `project.godot`。

## 当前进度

- [x] 导入课程初始工程（素材 + `project.godot`）
- [ ] 场景搭建 / TileMap
- [ ] 角色基础移动
- [ ] 子弹与射击
- [ ] AnimationPlayer 动画
- [ ] Tween 补间
- [ ] 无人机敌人
- [ ] 分组（groups）
- [ ] 2D 光照
- [ ] Shader 效果

## 已内置的输入映射

`project.godot` 里已经配好，代码里可直接用：

| 动作 | 按键 |
|---|---|
| `left` | A |
| `right` | D |
| `jump` | 空格 |
| `shoot` | 鼠标左键 |

## 关于初始素材来源（如实说明）

本项目的初始工程（美术、音效、`project.godot` 配置）来自付费课程
《Godot 零基础实战入门：手把手带你完成 7 个小游戏》的 Metroid 章节。

**游戏逻辑代码由我自己跟随课程逐步编写**，每次提交都对应我实际写下的进度。
课程素材版权归原作者所有，本仓库仅作个人学习记录用途。

## 开发工作流

```bash
# 在 Godot 里改完代码后
git add 02.Metroid
git commit -m "feat(metroid): 完成角色基础移动"
git push
```

## 学到的 Godot 知识点

<!-- 边做边记 -->

## 踩过的坑

<!-- 记录问题和解决方案 -->
