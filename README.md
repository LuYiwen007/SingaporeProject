# SingaporeProject

##主要功能

### 1. AI 智能对话助手
-基于 Qwen AI 的智能对话系统
-支持自然语言问答，可询问单词含义、用法、例句等
-会话上下文保持，支持多轮对话
-智能建议提示，快速开始对话
-实时响应，流畅的对话体验

### 2. 用户体验
-现代化 UI 设计，遵循 iOS 设计规范
-支持系统深色/浅色模式
-响应式布局，适配不同屏幕尺寸
-流畅的动画和过渡效果
-直观的交互设计

## 技术栈

-**开发语言**: Swift 5.9+
-**UI 框架**: SwiftUI
-**最低系统要求**: iOS 17.0+
-**AI 服务**: 阿里云百炼平台 Qwen AI
-**架构模式**: MVVM
-**数据存储**: 本地数据模型（可扩展为 Core Data）

## 📁 项目结构

Team Proj/
├── Team_ProjApp.swift          # 应用入口
├── ContentView.swift            # 主视图容器
│
├── Models/                      # 数据模型
│   ├── Word.swift               # 单词模型
│   ├── ChatMessage.swift        # 聊天消息模型
│   └── QuizQuestion.swift       # 测验问题模型
│
├── Services/                    # 服务层
│   ├── QwenAPIService.swift     # Qwen AI API 服务
│   └── VocabularyDatabase.swift # 词汇数据库（预留）
│
├── Views/                       # 视图层
│   ├── Chat/                    # 聊天相关视图
│   │   ├── ChatView.swift       # 聊天主视图
│   │   └── MessageBubbleView.swift  # 消息气泡视图
│   │
│   ├── Vocabulary/              # 词汇相关视图
│   │   ├── VocabularyListView.swift  # 词汇列表
│   │   ├── WordCardView.swift   # 单词卡片
│   │   └── WordDetailView.swift # 单词详情
│   │
│   └── Practice/                # 练习相关视图
│       ├── PracticeView.swift   # 练习主视图
│       └── QuizQuestionView.swift  # 测验问题视图
│
└── Theme/                       # 主题配置
    └── AppTheme.swift           # 应用主题（颜色、字体、间距等）
```

## 安装与配置

### 环境要求

- macOS 14.0+ (用于开发)
- Xcode 15.0+
- iOS 17.0+ 设备或模拟器
- CocoaPods（如需要，当前项目未使用）

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd SingaporeProject
   ```

2. **打开项目**

   open "Team Proj.xcodeproj"
   

3. **配置 API 密钥**
   
   在运行应用前，需要配置你自己的 Qwen AI API 密钥。
   
   打开 `Team Proj/Services/QwenAPIService.swift`，修改以下配置：
   
   private let apiKey = "your-api-key-here"
   private let appId = "your-app-id-here"
   
   
   **获取 API 密钥步骤**:
   1. 访问 [阿里云百炼平台](https://bailian.console.aliyun.com/)
   2. 注册/登录账号
   3. 创建智能体应用
   4. 获取 API Key 和 App ID
   5. 将密钥填入代码中

4. **运行项目**
   - 在 Xcode 中选择目标设备（模拟器或真机）
   - 按 `Cmd + R` 运行项目

## 📖 使用说明

### AI 对话助手

1. 打开应用，进入 AI 对话界面
2. 在输入框中输入问题，例如：
   - "What does 'learn' mean?"
   - "Give me examples of 'important'"
   - "How can I improve my vocabulary?"
3. 点击发送按钮或按回车键发送消息
4. AI 会实时回复你的问题
5. 点击右上角垃圾桶图标可清空对话历史
