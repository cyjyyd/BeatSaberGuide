# BeatSaber Guide 部署指南

本项目支持两种部署方式：**GitHub Pages** 和 **Cloudflare Pages**。

---

## 方案一：GitHub Pages 部署（推荐）

### 前提条件
- GitHub 账号
- 项目代码已推送到 GitHub 仓库

### 步骤 1：推送代码到 GitHub

```bash
# 初始化 Git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: Jekyll migration"

# 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/你的用户名/BeatSaberGuide-jekyll-migration.git

# 推送到 main 分支
git branch -M main
git push -u origin main
```

### 步骤 2：启用 GitHub Pages

1. 进入 GitHub 仓库页面
2. 点击 **Settings** → **Pages**
3. 在 **Source** 下拉菜单中选择 **GitHub Actions**
4. 保存

### 步骤 3：等待构建完成

- GitHub Actions 会自动运行 `.github/workflows/pages.yml` 中定义的构建流程
- 构建完成后，站点将部署到 `https://你的用户名.github.io/仓库名/`
- 如果使用自定义域名，在 Pages 设置中添加 CNAME 文件或配置 DNS

### 自定义域名配置

如果你的域名是 `bs.wgzeyu.com`：

1. 在仓库根目录创建 `CNAME` 文件，内容为：
   ```
   bs.wgzeyu.com
   ```

2. 在域名 DNS 设置中添加 CNAME 记录：
   ```
   bs.wgzeyu.com → 你的用户名.github.io
   ```

3. 修改 `_config.yml` 中的 URL：
   ```yaml
   url: "https://bs.wgzeyu.com"
   baseurl: ""
   ```

---

## 方案二：Cloudflare Pages 部署

### 前提条件
- Cloudflare 账号
- 项目代码已推送到 GitHub 或 GitLab

### 步骤 1：连接仓库

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. 进入 **Workers & Pages** → **Create application** → **Pages**
3. 选择 **Connect to Git**
4. 授权并选择你的 GitHub 仓库

### 步骤 2：配置构建设置

在配置页面填写：

| 设置项 | 值 |
|--------|-----|
| Production branch | main |
| Build command | `bundle exec jekyll build` |
| Build output directory | `_site` |

### 步骤 3：配置环境变量

点击 **Environment variables** 添加：

| 变量名 | 值 |
|--------|-----|
| RUBY_VERSION | 3.3.0 |

### 步骤 4：部署

点击 **Save and Deploy**，Cloudflare 会自动构建并部署。

### 自定义域名配置

1. 在 Cloudflare Pages 项目中进入 **Custom domains**
2. 点击 **Set up a custom domain**
3. 输入 `bs.wgzeyu.com`
4. Cloudflare 会自动配置 DNS（如果域名托管在 Cloudflare）

---

## 方案对比

| 特性 | GitHub Pages | Cloudflare Pages |
|------|-------------|------------------|
| 免费额度 | 100GB/月带宽 | 无限带宽 |
| 构建时间 | ~2分钟 | ~1分钟 |
| 自定义插件 | ✅ 支持（通过 Actions） | ✅ 原生支持 |
| 中国访问 | 较慢 | 较快（有国内节点） |
| 构建日志 | 公开 | 私有 |
| 自定义域名 | 支持 | 支持 |
| HTTPS | 自动 | 自动 |

---

## 常见问题

### Q: 构建失败怎么办？

1. 检查构建日志中的错误信息
2. 确保 `Gemfile.lock` 已提交（可选，但推荐）
3. 检查 Ruby 版本兼容性

### Q: 样式或图片加载失败？

1. 检查路径是否使用了 `relative_url` 或 `absolute_url` 过滤器
2. 如果部署在子路径（如 `/仓库名/`），确保 `baseurl` 配置正确

### Q: 如何更新站点？

```bash
git add .
git commit -m "Update content"
git push
```

推送后，GitHub Actions 或 Cloudflare Pages 会自动重新构建部署。

---

## 本地预览

部署前可以本地预览：

```bash
bundle install
bundle exec jekyll serve
```

访问 http://127.0.0.1:4000 查看效果。