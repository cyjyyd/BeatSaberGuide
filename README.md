# BeatSaberGuide

Beat Saber 节奏光剑新手教程网站，托管于 GitHub Pages。

**网址**: [https://bs.wgzeyu.com](https://bs.wgzeyu.com)

---

## 目录结构

```
BeatSaberGuide/
├── _config.yml          # Jekyll 配置文件
├── Gemfile              # Ruby 依赖定义
├── Gemfile.lock         # 依赖版本锁定
├── .ruby-version        # Ruby 版本指定
├── .github/
│   └── workflows/
│       └── pages.yml    # GitHub Actions 部署配置
├── wrangler.toml        # Cloudflare Pages 配置（可选）
├── _layouts/            # 页面布局模板
│   ├── default.html     # 基础布局
│   ├── guide.html       # 教程内容页布局
│   └── guide-frame.html # iframe框架页布局
├── _includes/           # 可复用组件
├── _plugins/            # Jekyll 插件
│   └── rainbow-tag.rb   # 自定义标签插件
├── assets/              # 静态资源（CSS、JS、图片、字体）
├── _guides/             # 教程 Markdown 内容
│   ├── pc-guide/        # PC平台教程
│   ├── oq-guide/        # Quest平台选择页
│   ├── oq-guide-qp/     # QuestPatcher教程
│   ├── oq-guide-bmbf/   # BMBF教程（已过时）
│   ├── buy/             # 购买教程
│   ├── pc-faq/          # 问题解答
│   ├── drive/           # 网盘页
│   └── songs/           # 曲包同步
├── speedlimit/          # 共享图片/视频资源
├── index.html           # 网站主页
└── README.md
```

---

## 如何修改教程内容

### 1. 找到对应的 Markdown 文件

所有教程内容都在 `_guides/` 目录下：

| 教程页面 | Markdown 文件路径 |
|----------|------------------|
| PC平台教程 | `_guides/pc-guide/guide.md` |
| Quest平台教程（选择页） | `_guides/oq-guide/guide.md` |
| QuestPatcher教程 | `_guides/oq-guide-qp/guide.md` |
| BMBF教程（已过时） | `_guides/oq-guide-bmbf/guide.md` |
| 购买教程 | `_guides/buy/guide.md` |
| 曲包同步 | `songs/readme.md` |

### 2. Markdown 基本语法

```markdown
## 章节标题 {#anchor-id}

段落内容，支持 **粗体**、*斜体*、`代码` 等格式。

### 子章节标题 {#sub-anchor}

- 列表项1
- 列表项2

[链接文字](../other-page/)
![图片描述](img/image.png)
```

### 3. 特殊格式

#### 自定义语法汇总表

| 语法 | 输出效果 | 用途 |
|------|----------|------|
| `[彩虹]文字[/彩虹]` | 彩虹色文字 | 高亮重要文字 |
| `[警告框]内容[/警告框]` | 红色背景警告框 | 提示注意事项 |
| `[彩虹框]内容[/彩虹框]` | 彩虹边框警告框 | 特殊重要提示 |
| `[懒加载]alt\|占位符\|真图[/懒加载]` | 点击加载图片 | 大图片优化 |
| `![alt](path.mp4)` | 自动播放视频 | 演示动画 |
| `[并排]![主图]\|![副图][/并排]` | 8:4并排布局 | 对比展示 |
| `![alt](img.png)` | 自动响应式 | 所有图片自动适配 |

#### 页面标题和简介
在 `guide.md` 的 Front Matter 中配置：
```yaml
---
title: "Beat Saber 新手教程 - PC平台"
heading: "Beat Saber 新手教程 - PC平台"
lead: "本教程**[彩虹]仅适用于Steam等PC平台[/彩虹]**"
---
```

#### 彩虹文字（文字本身彩虹色）
```markdown
**[彩虹]这是彩虹高亮文字[/彩虹]**
```

#### 彩虹背景警告框（整段彩虹边框动画）
```markdown
[彩虹框]
这里是警告内容，支持多行文字和链接。
[/彩虹框]
```

#### 红色背景警告框
```markdown
[警告框]
这里是警告内容。
[/警告框]
```

#### 懒加载图片
```markdown
[懒加载]图片描述|占位符路径|真实图片路径[/懒加载]
```

#### 视频（MP4自动转换为video标签）
```markdown
![视频描述](../speedlimit/pc-guide/demo.mp4)
```

#### 并排图片布局（主图8:副图4）
```markdown
[并排]![主图描述](img/main.png)|![副图描述](img/sub.png)[/并排]
```

#### 普通图片（自动添加响应式类）
```markdown
![图片描述](img/image.png)
```
所有图片会自动添加 `img-responsive img-thumbnail` 类，确保在移动端正确缩放。

### 4. 链接处理

#### 内部链接（相对路径）
```markdown
[点我查看问题解答](../pc-faq/)
```
自动转换为同站链接，无需特殊处理。

#### 外部链接（自动添加新窗口打开）
```markdown
[访问BeatSaver](https://beatsaver.com/)
```
外部链接（以 `http://` 或 `https://` 开头）自动添加 `target="_blank"` 属性，在新窗口打开。

#### 在自定义标签内的链接
自定义标签（警告框、彩虹框等）内的 Markdown 链接也会正确转换：
```markdown
[警告框]
请[点我查看教程](../pc-guide/)了解详情。
[/警告框]
```

### 5. 侧边栏导航配置

在每个 `guide.md` 文件的 Front Matter 配置侧边栏：

```yaml
---
title: "页面标题"
layout: guide
sidebar:
  - id: chapter1
    title: 第一章
  - id: chapter2
    title: 第二章
    children:
      - id: section2-1
        title: 2.1 小节
---
```

`id` 对应章节标题的锚点 ID：`## 章节标题 {#chapter1}`

---

## 本地预览

需要 Ruby 环境，安装 Jekyll 后运行：

```bash
# 安装依赖
bundle install

# 启动本地服务器
bundle exec jekyll serve

# 访问 http://localhost:4000
```

---

## 部署

本项目支持两种部署方式：**GitHub Pages** 和 **Cloudflare Pages**。

> **重要提示**：本项目使用自定义 Jekyll 插件（`_plugins/rainbow-tag.rb`），GitHub Pages 默认不支持自定义插件，必须使用 GitHub Actions 进行部署。Cloudflare Pages 原生支持自定义插件。

---

### 方案一：GitHub Pages 部署（推荐）

#### 1. 创建 GitHub Actions 配置文件

在 `.github/workflows/` 目录下创建 `pages.yml` 文件：

```yaml
# .github/workflows/pages.yml
name: Deploy Jekyll site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.3'
          bundler-cache: true

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4

      - name: Build with Jekyll
        run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
        env:
          JEKYLL_ENV: production

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

#### 2. 启用 GitHub Pages

1. 进入 GitHub 仓库 → **Settings** → **Pages**
2. 在 **Source** 下拉菜单中选择 **GitHub Actions**
3. 保存

#### 3. 确保 Ruby 版本一致

创建 `.ruby-version` 文件（与 GitHub Actions 中配置的版本一致）：
```
3.3.0
```

#### 4. 提交 Gemfile.lock（推荐）

确保本地和远程使用相同的依赖版本：
```bash
bundle install
git add Gemfile.lock
git commit -m "Lock dependencies"
```

---

### 方案二：Cloudflare Pages 部署

Cloudflare Pages 原生支持自定义 Jekyll 插件，配置更简单。

#### 1. 连接仓库

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. 进入 **Workers & Pages** → **Create application** → **Pages**
3. 选择 **Connect to Git**
4. 授权并选择你的 GitHub 仓库

#### 2. 配置构建设置

| 设置项 | 值 |
|--------|-----|
| Production branch | main |
| Build command | `bundle exec jekyll build` |
| Build output directory | `_site` |

#### 3. 配置环境变量

点击 **Environment variables** 添加：

| 变量名 | 值 |
|--------|-----|
| RUBY_VERSION | 3.3.0 |

#### 4. 可选：创建 wrangler.toml

在仓库根目录创建 `wrangler.toml`（可替代 Cloudflare Dashboard 配置）：

```toml
name = "beatsaber-guide"
compatibility_date = "2024-01-01"
pages_build_output_dir = "_site"

[build]
command = "bundle exec jekyll build"

[build.environment]
RUBY_VERSION = "3.3.0"
```

---

### 确保远程与本地效果一致

#### 必须配置的文件

| 文件 | 用途 |
|------|------|
| `Gemfile` | 定义 Ruby 依赖 |
| `Gemfile.lock` | 锁定依赖版本（提交此文件确保一致性） |
| `.ruby-version` | 指定 Ruby 版本 |
| `_plugins/rainbow-tag.rb` | 自定义标签插件（必须提交） |
| `.github/workflows/pages.yml` | GitHub Actions 构建配置 |

#### 常见不一致问题

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| 自定义标签不生效 | GitHub Pages 默认禁用插件 | 使用 GitHub Actions 部署 |
| 样式加载失败 | baseurl 配置错误 | 检查 `_config.yml` 中的 baseurl |
| 图片路径错误 | 相对路径问题 | 使用 `relative_url` 过滤器 |
| 构建失败 | Ruby 版本不一致 | 确保 `.ruby-version` 与 Actions 配置一致 |
| 依赖版本冲突 | 未提交 Gemfile.lock | 提交 `Gemfile.lock` 文件 |

#### 自定义域名配置

**GitHub Pages：**
1. 创建 `CNAME` 文件，内容为域名（如 `bs.wgzeyu.com`）
2. 在 DNS 添加 CNAME 记录指向 `你的用户名.github.io`
3. 修改 `_config.yml`：
   ```yaml
   url: "https://bs.wgzeyu.com"
   baseurl: ""
   ```

**Cloudflare Pages：**
1. 在项目设置中进入 **Custom domains**
2. 添加自定义域名
3. Cloudflare 自动配置 DNS（如果域名托管在 Cloudflare）

---

### 方案对比

| 特性 | GitHub Pages | Cloudflare Pages |
|------|-------------|------------------|
| 免费额度 | 100GB/月带宽 | 无限带宽 |
| 构建时间 | ~2分钟 | ~1分钟 |
| 自定义插件 | ✅ 需 GitHub Actions | ✅ 原生支持 |
| 中国访问 | 较慢 | 较快（有国内节点） |
| 构建日志 | 公开 | 私有 |
| 配置复杂度 | 中等 | 简单 |

---

## 协议

教程内容采用 [CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/) 授权。

允许在醒目注明原作者及原链接并保持内容同步更新的前提下完整转载。

作者：WGzeyu