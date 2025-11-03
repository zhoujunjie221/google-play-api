# 本地修改说明 (Local Modifications)

## 概述 (Overview)

本项目使用了本地集成的 `google-play-scraper` 库（版本 10.0.0），而不是从 npm 安装。这样做是为了修复原始库中的一个 bug。

This project uses a locally integrated `google-play-scraper` library (v10.0.0) instead of installing it from npm. This was done to fix a bug in the original library.

## 修改内容 (Modifications)

### 1. 集成本地 google-play-scraper

**文件位置 (Location):** `google-play-scraper/`

从 GitHub 仓库 (https://github.com/facundoolano/google-play-scraper) 的 v10.0.0 标签复制了完整的源代码到本地。

Copied the complete source code from the GitHub repository (https://github.com/facundoolano/google-play-scraper) tag v10.0.0 to local directory.

### 2. Bug 修复 (Bug Fix)

**文件 (File):** `google-play-scraper/lib/utils/mappingHelpers.js`

**问题 (Issue):** 
当某些应用的分类数据为 `undefined` 时，`extractCategories` 函数会抛出错误：
```
TypeError: Cannot read properties of undefined (reading 'length')
```

When category data is `undefined` for certain apps, the `extractCategories` function throws an error:
```
TypeError: Cannot read properties of undefined (reading 'length')
```

**修复 (Fix):**

1. **第 77 行 (Line 77):** 添加了 `!searchArray` 检查
   ```javascript
   // 修复前 (Before):
   if (searchArray === null || searchArray.length === 0) return categories;
   
   // 修复后 (After):
   if (!searchArray || searchArray === null || searchArray.length === 0) return categories;
   ```

2. **第 86-90 行 (Lines 86-90):** 在递归调用前检查 sub 是否为 undefined
   ```javascript
   // 修复前 (Before):
   searchArray.forEach((sub) => {
     extractCategories(sub, categories);
   });
   
   // 修复后 (After):
   searchArray.forEach((sub) => {
     if (sub) {
       extractCategories(sub, categories);
     }
   });
   ```

**相关 Issue (Related Issue):** https://github.com/facundoolano/google-play-scraper/issues/720

### 3. 更新依赖配置 (Updated Dependencies)

**文件 (File):** `package.json`

- 移除了 `google-play-scraper` npm 依赖
- 添加了 `google-play-scraper` 的直接依赖项：
  - `cheerio: ^1.0.0-rc.12`
  - `debug: ^3.1.0`
  - `got: ^11.8.6`
  - `memoizee: ^0.4.14`
  - `ramda: ^0.29.0`
- 移除了 `postinstall` 脚本（不再需要自动修复）

Removed `google-play-scraper` npm dependency and added its direct dependencies instead.
Removed `postinstall` script (no longer needed for automatic patching).

### 4. 更新导入路径 (Updated Import Path)

**文件 (File):** `lib/index.js`

```javascript
// 修复前 (Before):
import gplay from "google-play-scraper";

// 修复后 (After):
import gplay from "../google-play-scraper/index.js";
```

## 测试 (Testing)

修复后的 API 可以正常处理之前会报错的应用，例如：

The fixed API can now handle apps that previously caused errors, such as:

```bash
curl -H "x-api-key: YOUR_KEY" \
  "http://localhost:8080/api/apps/magalingpeso.cash.loan?country=ph"
```

返回完整的应用信息，包括标题、开发者、分类等。

Returns complete app information including title, developer, categories, etc.

## 维护说明 (Maintenance Notes)

1. **更新 google-play-scraper:** 如果需要更新到新版本，需要手动从 GitHub 下载新版本并重新应用修复。

   To update google-play-scraper to a new version, manually download the new version from GitHub and reapply the fix.

2. **监控上游修复:** 定期检查 https://github.com/facundoolano/google-play-scraper/issues/720 以了解官方是否已修复此问题。

   Monitor https://github.com/facundoolano/google-play-scraper/issues/720 to see if the official fix is released.

3. **依赖管理:** 运行 `npm install` 时不会覆盖本地的 `google-play-scraper` 目录。

   Running `npm install` will not overwrite the local `google-play-scraper` directory.

## 文件清单 (File Checklist)

- ✅ `google-play-scraper/` - 本地集成的库（已修复）
- ✅ `lib/index.js` - 更新了导入路径
- ✅ `package.json` - 更新了依赖配置
- ✅ `README.md` - 更新了文档说明
- ✅ `MODIFICATIONS.md` - 本文档
- ❌ `scripts/fix-google-play-scraper.js` - 已删除（不再需要）
- ❌ `BUGFIX.md` - 已删除（信息已合并到本文档）

