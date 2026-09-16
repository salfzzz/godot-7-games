# 01. Frogger — 过马路

**状态：** ✅ 已完成

2D 俯视视角，操作角色穿过马路躲避车辆。

## 文件夹结构

```
01.Frogger/
├── README.md            本说明
├── builds/windows/      导出的 Windows 可执行版（Git LFS 管理）
└── finished-frogger/    Godot 项目本体（用 Godot 4 打开这里的 project.godot）
```

## 怎么打开

用 Godot 4 打开 `finished-frogger/project.godot`。

## 关于代码来源（如实说明）

本项目是**跟随付费课程《Godot 零基础实战入门：手把手带你完成 7 个小游戏》
的 Frogger 章节逐行跟练完成**的，代码结构、美术与音效素材均由课程提供。
文件夹名 `finished-frogger` 沿用课程原名。

仓库里放它，是为了记录我学习和动手实践的过程，**不代表这是我独立原创的作品**。
课程素材版权归原作者所有，本仓库仅作个人学习记录用途。

## 我自己做的部分

- 在 Godot 中打开工程、跟练并导出 Windows 可执行版
- 导出配置 `export_presets.cfg` 指向本机路径，构建产物见 `builds/windows/`

## 学到的 Godot 知识点

<!-- 在这里补充你自己的笔记 -->

- 场景（Scene）与节点（Node）树结构
- `_process` / `_physics_process` 的区别
- 信号（signal）连接与自定义信号
- Area2D 碰撞检测
- 用 `export var` 在编辑器里暴露参数

## 踩过的坑

<!-- 记录遇到的问题和解决方案 -->
