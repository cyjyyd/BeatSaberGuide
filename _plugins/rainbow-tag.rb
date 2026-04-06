# Jekyll插件：处理自定义语法
# 1. 将 [彩虹]...[/彩虹] 标签转换为带CSS类的HTML
# 2. 将 mp4 视频引用转换为 video 标签
# 3. 将 [彩虹框]...[/彩虹框] 转换为彩虹背景警告框（整段）
# 4. 将 [警告框]...[/警告框] 转换为红色背景警告框（整段）
# 5. 将 [懒加载]alt|占位符|真图[/懒加载] 转换为懒加载图片
# 6. 将 [并排]![主图](path1)|![副图](path2)[/并排] 转换为并排图片布局

# 在渲染前处理所有页面和文档
Jekyll::Hooks.register [:pages, :documents], :pre_render do |document|
  if document.extname == '.md' && document.content
    content = document.content

    # 1. 处理彩虹标签：使用特殊标记保护彩虹内容
    content = content.gsub(/\[彩虹\](.*?)\[\/彩虹\]/m) do |match|
      inner = match.match(/\[彩虹\](.*?)\[\/彩虹\]/m)[1]
      "<!--RAINBOW_START-->#{inner}<!--RAINBOW_END-->"
    end

    # 2. 处理彩虹框标签：整段彩虹背景警告框
    content = content.gsub(/\[彩虹框\](.*?)\[\/彩虹框\]/m) do |match|
      inner = match.match(/\[彩虹框\](.*?)\[\/彩虹框\]/m)[1]
      "<!--RAINBOWBOX_START-->#{inner}<!--RAINBOWBOX_END-->"
    end

    # 3. 处理警告框标签：整段红色背景警告框
    content = content.gsub(/\[警告框\](.*?)\[\/警告框\]/m) do |match|
      inner = match.match(/\[警告框\](.*?)\[\/警告框\]/m)[1]
      "<!--WARNBOX_START-->#{inner}<!--WARNBOX_END-->"
    end

    # 4. 处理懒加载图片：[懒加载]alt|占位符|真图[/懒加载]
    content = content.gsub(/\[懒加载\]([^\|]+)\|([^\|]+)\|([^\|]+)\[\/懒加载\]/) do |match|
      parts = match.match(/\[懒加载\]([^\|]+)\|([^\|]+)\|([^\|]+)\[\/懒加载\]/)
      alt = parts ? parts[1].strip : ""
      placeholder = parts ? parts[2].strip : ""
      real_img = parts ? parts[3].strip : ""
      img_id = "lazy_" + real_img.gsub(/[^a-zA-Z0-9]/, '_').gsub(/_+/, '_')
      "<!--LAZYIMG_START#{alt}||#{placeholder}||#{real_img}||#{img_id}LAZYIMG_END-->"
    end

    # 5. 处理 mp4 视频：将 ![alt](path.mp4) 转换为 video 标签占位符
    content = content.gsub(/!\[([^\]]*)\]\(([^\)]+\.mp4)\)/) do |match|
      alt_match = match.match(/!\[([^\]]*)\]/)
      path_match = match.match(/\]\(([^\)]+\.mp4)\)/)
      alt = alt_match ? alt_match[1] : ""
      path = path_match ? path_match[1] : ""
      path_no_ext = path.sub(/\.mp4$/, '')
      video_id = "video_" + path_no_ext.gsub(/[^a-zA-Z0-9]/, '_')
      "<!--VIDSTART#{alt}||#{path_no_ext}||#{video_id}VIDEND-->"
    end

    # 6. 处理并排图片：[并排]![主图alt](主图path)|![副图alt](副图path)[/并排]
    content = content.gsub(/\[并排\]!\[([^\]]*)\]\(([^\)]+)\)\|!\[([^\]]*)\]\(([^\)]+)\)\[\/并排\]/) do |match|
      parts = match.match(/\[并排\]!\[([^\]]*)\]\(([^\)]+)\)\|!\[([^\]]*)\]\(([^\)]+)\)\[\/并排\]/)
      main_alt = parts ? parts[1] : ""
      main_path = parts ? parts[2] : ""
      sub_alt = parts ? parts[3] : ""
      sub_path = parts ? parts[4] : ""
      "<!--SIDEXSIDE_START#{main_alt}||#{main_path}||#{sub_alt}||#{sub_path}SIDEXSIDE_END-->"
    end

    document.content = content
  end
end

# 在渲染后转换临时标记为最终HTML
Jekyll::Hooks.register [:pages, :documents], :post_render do |document|
  if document.output
    output = document.output

    # 1. 将彩虹标记转换为最终的HTML
    output = output.gsub(/<!--RAINBOW_START-->(.*?)<!--RAINBOW_END-->/m) do
      inner = $1 || ""
      '<b class="rainbow2">' + inner + '</b>'
    end

    # 处理原始的 [彩虹]...[/彩虹] 标签（用于 markdownify 处理的内容）
    output = output.gsub(/\[彩虹\](.*?)\[\/彩虹\]/m) do
      inner = $1 || ""
      '<b class="rainbow2">' + inner + '</b>'
    end

    # 3. 将警告框标记转换为最终的HTML
    output = output.gsub(/<!--WARNBOX_START-->(.*?)<!--WARNBOX_END-->/m) do
      inner = $1 || ""
      inner = inner.gsub(/<\/p>/, '').gsub(/<p>/, '').strip
      # 处理内部的 Markdown 链接 [text](url)
      inner = inner.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '<a href="\2">\1</a>')
      '<div class="intro2 clearfix"><p><i class="fa fa-exclamation-triangle"></i> ' + inner + '</p></div>'
    end

    # 处理原始的 [警告框]...[/警告框] 标签
    output = output.gsub(/\[警告框\](.*?)\[\/警告框\]/m) do
      inner = $1 || ""
      inner = inner.gsub(/<\/p>/, '').gsub(/<p>/, '').strip
      # 处理内部的 Markdown 链接 [text](url)
      inner = inner.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '<a href="\2">\1</a>')
      '<div class="intro2 clearfix"><p><i class="fa fa-exclamation-triangle"></i> ' + inner + '</p></div>'
    end

    # 2. 将彩虹框标记转换为最终的HTML（同样处理链接）
    output = output.gsub(/<!--RAINBOWBOX_START-->(.*?)<!--RAINBOWBOX_END-->/m) do
      inner = $1 || ""
      # 移除 markdown 生成的 <p> 和 </p> 标签
      inner = inner.gsub(/<\/p>/, '').gsub(/<p>/, '').strip
      # 处理内部的 Markdown 链接 [text](url)
      inner = inner.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '<a href="\2">\1</a>')
      '<div class="intro2 clearfix rainbownote"><p><i class="fa fa-exclamation-triangle"></i> ' + inner + '</p></div>'
    end

    # 处理原始的 [彩虹框]...[/彩虹框] 标签（同样处理链接）
    output = output.gsub(/\[彩虹框\](.*?)\[\/彩虹框\]/m) do
      inner = $1 || ""
      inner = inner.gsub(/<\/p>/, '').gsub(/<p>/, '').strip
      inner = inner.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '<a href="\2">\1</a>')
      '<div class="intro2 clearfix rainbownote"><p><i class="fa fa-exclamation-triangle"></i> ' + inner + '</p></div>'
    end

    # 4. 将懒加载图片标记转换为最终的HTML
    output = output.gsub(/<!--LAZYIMG_START([^\|]*)\|\|([^\|]*)\|\|([^\|]*)\|\|([^\|]*)LAZYIMG_END-->/) do
      alt = $1 ? $1.strip : ""
      placeholder = $2 ? $2.strip : ""
      real_img = $3 ? $3.strip : ""
      img_id = $4 ? $4.strip : ""
      '<p><img src="' + placeholder + '" data-src="' + real_img + '" class="lzy_img img-responsive img-thumbnail" id="' + img_id + '" onclick="limg(\'' + img_id + '\');" alt="' + alt + '"></p>'
    end

    # 5. 将视频标记转换为 video 标签
    output = output.gsub(/<!--VIDSTART([^\|]*)\|\|([^\|]*)\|\|([^\|]*)VIDEND-->/) do
      alt = $1 || ""
      path = $2 || ""
      video_id = $3 || ""
      # 直接设置 src，不使用懒加载
      '<video id="' + video_id + '" muted playsinline src="' + path + '.mp4" class="img-responsive img-thumbnail" autoplay="autoplay" loop="loop" style="max-width:100%;height:auto;">你的浏览器不支持播放当前视频</video>'
    end

    # 6. 将并排图片标记转换为 Bootstrap 布局
    output = output.gsub(/<!--SIDEXSIDE_START([^\|]*)\|\|([^\|]*)\|\|([^\|]*)\|\|([^\|]*)SIDEXSIDE_END-->/) do
      main_alt = $1 ? $1.strip : ""
      main_path = $2 ? $2.strip : ""
      sub_alt = $3 ? $3.strip : ""
      sub_path = $4 ? $4.strip : ""
      '<div class="row"><div class="col-md-8"><img src="' + main_path + '" alt="' + main_alt + '" class="img-responsive img-thumbnail" /></div><div class="col-md-4"><img src="' + sub_path + '" alt="' + sub_alt + '" class="img-responsive img-thumbnail" /></div></div>'
    end

    # 最后修复：移除多余的 </p> 标签在 </div> 后面
    output = output.gsub(/<\/div><\/p>/, '</div>')

    # 处理 Markdown 图片语法：![alt](url) 转换为 img 标签（用于 HTML 标签内的内容）
    # 这必须在处理链接之前，否则会被错误地转换为链接
    output = output.gsub(/!\[([^\]]*)\]\(([^)]+)\)/) do
      alt = $1 || ""
      url = $2 || ""
      '<img src="' + url + '" alt="' + alt + '" class="img-responsive img-thumbnail" />'
    end

    # 为 Kramdown 生成的 img 标签添加响应式类（排除已有 img-responsive 类的图片）
    output = output.gsub(/<img\s([^>]*?)(\s*\/?)>/) do |match|
      attrs = $1 || ""
      slash = $2 || ""
      # 移除 attrs 中可能存在的尾部斜杠
      attrs = attrs.rstrip.sub(/\s*\/$/, '')
      # 检查是否已经有 img-responsive 类
      if attrs.include?('img-responsive')
        match  # 保持原样
      elsif attrs.include?('class="')
        # 有其他类但没 img-responsive，添加到现有 class
        attrs = attrs.sub(/class="([^"]*)"/, 'class="\1 img-responsive img-thumbnail"')
        '<img ' + attrs + ' />'
      else
        # 没有 class 属性，添加新的
        '<img ' + attrs + ' class="img-responsive img-thumbnail" />'
      end
    end

    # 然后处理剩余的 Markdown 链接（用于 HTML 标签内的内容）
    # 匹配 [text](url) 但排除已转换的 <a> 标签
    output = output.gsub(/\[([^\]]+)\]\(([^)]+)\)/) do |match|
      text = $1 || ""
      url = $2 || ""
      # 判断是否是外部链接（http:// 或 https:// 开头）
      is_external = url.match?(/^https?:\/\//)
      if is_external
        '<a href="' + url + '" target="_blank" rel="noopener noreferrer">' + text + '</a>'
      else
        '<a href="' + url + '">' + text + '</a>'
      end
    end

    # 为已转换的外部链接添加 target="_blank"
    output = output.gsub(/<a href="(https?:\/\/[^"]+)"(?! target)/) do
      url = $1
      '<a href="' + url + '" target="_blank" rel="noopener noreferrer"'
    end

    document.output = output
  end
end