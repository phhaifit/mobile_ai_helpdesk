# Jarvis Helpdesk - Design System & UI Guidelines
**For Ticket Management Feature (React CSR Implementation)**

---

## 📋 Table of Contents
1. [Color Palette](#-color-palette)
2. [Typography](#-typography)
3. [Layout & Spacing](#-layout--spacing)
4. [UI Components](#-ui-components)
5. [Architecture & React Components](#-architecture--react-components)
6. [Implementation Examples](#-implementation-examples)

---

## 🎨 Color Palette

### Primary Colors
```
Primary Blue (Messenger Style)
  - HEX: #0084FF
  - RGB: (0, 132, 255)
  - Usage: Primary CTA, Links, Selected states, Accents
  - React: <button className="btn-primary">

Primary Purple
  - HEX: #5E5CE6
  - RGB: (94, 92, 230)
  - Usage: Alternative primary, badges, special highlights
  
Dark Blue (Header/Navigation)
  - HEX: #0D1B3E
  - RGB: (13, 27, 62)
  - Usage: Dark backgrounds, contrasting elements
```

### Neutral Colors
```
Background Grey
  - HEX: #F8F9FD
  - RGB: (248, 249, 253)
  - Usage: Page backgrounds, card backgrounds
  - CSS: background-color: #F8F9FD;

Text Primary
  - HEX: #1C1E21
  - RGB: (28, 30, 33)
  - Usage: Main text content, headings
  - CSS: color: #1C1E21;

Input Background
  - HEX: #F0F2F5
  - RGB: (240, 242, 245)
  - Usage: Input fields, form backgrounds
  - CSS: background-color: #F0F2F5;

Bubble Grey (Chat/Message)
  - HEX: #E9E9EB
  - RGB: (233, 233, 235)
  - Usage: Received message bubbles, secondary backgrounds
  
Divider Color
  - HEX: #E0E0E0
  - RGB: (224, 224, 224)
  - Usage: Borders, dividers, separators
  - CSS: border-color: #E0E0E0;
```

### Status Colors
```
Online/Success Green
  - HEX: #31A24C
  - RGB: (49, 162, 76)
  - Usage: Online status, approval, success states
  
Warning/Alert Orange
  - HEX: #FF9500 (inferred from common patterns)
  - Usage: Warning badges, medium priority
  
Error Red
  - HEX: #E4163A (inferred from common patterns)
  - Usage: Error states, high priority, destructive actions
  
Info Blue (Same as Primary)
  - HEX: #0084FF
  - Usage: Information badges, processing states
```

### CSS Variables (Recommended for React)
```css
:root {
  /* Primary */
  --color-primary-blue: #0084FF;
  --color-primary-purple: #5E5CE6;
  --color-dark-blue: #0D1B3E;

  /* Neutral */
  --color-bg-grey: #F8F9FD;
  --color-text-primary: #1C1E21;
  --color-input-bg: #F0F2F5;
  --color-bubble-grey: #E9E9EB;
  --color-divider: #E0E0E0;

  /* Status */
  --color-success-green: #31A24C;
  --color-warning-orange: #FF9500;
  --color-error-red: #E4163A;
  --color-info-blue: #0084FF;

  /* Utilities */
  --color-white: #FFFFFF;
  --color-gray-light: #F5F5F5;
  --color-gray-medium: #999999;
  --color-gray-dark: #666666;
}
```

---

## 📝 Typography

### Font Family
```
Primary Font: System Default (San Francisco / Segoe UI / Roboto)
  - Recommended: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif

Fallback Stack:
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 
               'Helvetica Neue', Arial, sans-serif;
```

### Heading Styles

**H1 - Page Title**
```
Font Size: 20px / 18px (mobile)
Font Weight: 700 (Bold)
Line Height: 1.4
Color: #1C1E21 (Text Primary)
Margin: 16px 0 8px 0
Example: "Danh sách khách hàng", "Phòng chat"
```

**H2 - Section Title**
```
Font Size: 18px / 16px (mobile)
Font Weight: 700 (Bold)
Line Height: 1.3
Color: #1C1E21
Margin: 12px 0 8px 0
```

**H3 - Subsection Title**
```
Font Size: 16px
Font Weight: 600 (Semi-bold)
Line Height: 1.3
Color: #1C1E21
Margin: 8px 0 4px 0
```

### Body Text Styles

**Body Large (Default)**
```
Font Size: 14px
Font Weight: 400 (Regular)
Line Height: 1.5
Color: #1C1E21
Usage: Main content, descriptions
```

**Body Medium**
```
Font Size: 13px
Font Weight: 400 (Regular)
Line Height: 1.5
Color: #1C1E21
Usage: Secondary content, helper text
```

**Body Small**
```
Font Size: 12px
Font Weight: 400 (Regular)
Line Height: 1.4
Color: #666666 (Gray medium)
Usage: Metadata, timestamps, captions
```

### Label/Caption Styles

**Label (Medium)**
```
Font Size: 13px
Font Weight: 500 (Medium)
Line Height: 1.4
Color: #1C1E21
Usage: Form labels, badge text
```

**Label (Small)**
```
Font Size: 11px
Font Weight: 500 (Medium)
Line Height: 1.3
Color: #999999 (Gray medium)
Usage: Sender names in chat, timestamps
```

### Font Weight Reference
```
400 = Regular (body text, normal content)
500 = Medium (labels, sidebar items, form labels)
600 = Semi-bold (subsection titles, emphasized text)
700 = Bold (main headings, page titles)
```

### CSS Font System
```css
/* Heading 1 */
.h1, h1 {
  font-size: 20px;
  font-weight: 700;
  line-height: 1.4;
  color: var(--color-text-primary);
  margin: 16px 0 8px 0;
}

/* Body Large */
body, .body-large {
  font-size: 14px;
  font-weight: 400;
  line-height: 1.5;
  color: var(--color-text-primary);
}

/* Label */
label, .label {
  font-size: 13px;
  font-weight: 500;
  color: var(--color-text-primary);
}

/* Caption/Small */
.caption, small {
  font-size: 12px;
  font-weight: 400;
  color: #666666;
}
```

---

## 📐 Layout & Spacing

### Spacing Scale (8px Grid System)
```
Base Unit: 8px

Spacing tokens:
  xs (4px)   - Used sparingly for tight layouts
  sm (8px)   - Default small gap
  md (12px)  - Default padding/margin
  lg (16px)  - Default large spacing
  xl (20px)  - Extra large gaps
  2xl (24px) - Double extra large
  3xl (32px) - Triple extra large
  4xl (40px) - Quadruple extra large
```

### Container & Max Width
```
Most screens use: Edge-to-edge layout on mobile

Desktop/Tablet:
  - Content max-width: Not specified (full width with padding)
  - Sidebar width: ~250px (estimated from layout)
  - Main content area: Flexible

Padding/Margin Standards:
  - Page padding: 16px (left/right)
  - Vertical spacing: 12px-16px between sections
  - Card padding: 12px-16px inside
  - Component gap: 8px-12px
```

### Common Layout Patterns

**Header Component**
```
Structure: Logo | Title | Actions
Padding: 16px (top/bottom), 16px (left/right)
Background: #FFFFFF (white)
Border bottom: 1px #E0E0E0
Height: ~56px (including padding)
```

**Sidebar Menu**
```
Width: ~250px (responsive: ~280px on 1200px+ screens)
Structure: Logo header | Expandable categories | Profile footer
Padding: 12-16px
Logo height: 28px + 16px padding = 44px header
```

**List View / Data Grid**
```
Row padding: 12px (vertical), 16px (horizontal)
Row height: ~48px (minimum)
Gap between rows: 0 (continuous list) or 8px (card layout)
```

**Form Field**
```
Input height: 40px (minimum)
Input padding: 10px (vertical), 12px (horizontal)
Label spacing: 4px below label text
Field gap: 12px between fields
```

### Responsive Breakpoints (Inferred)
```
Mobile: 0px - 600px
  - Full width layout
  - Sidebar hidden (hamburger menu)
  - Single column content

Tablet: 600px - 960px
  - 2-column layout possible
  - Sidebar visible/collapsible

Desktop: 960px+
  - Full 3-layout: Sidebar + Main + Panel
  - Multi-column supported
```

---

## 🧩 UI Components

### 1. Buttons

#### Primary Button
```jsx
/* React/JSX Structure */
<button className="btn btn-primary">
  Action Text
</button>

/* CSS Styling */
.btn {
  padding: 10px 16px;
  border-radius: 8px;
  border: none;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-primary {
  background-color: #0084FF;
  color: #FFFFFF;
}

.btn-primary:hover {
  background-color: #0073E6;
  box-shadow: 0 2px 8px rgba(0, 132, 255, 0.3);
}

.btn-primary:active {
  background-color: #0066CC;
}

.btn-primary:disabled {
  background-color: #CCCCCC;
  cursor: not-allowed;
  opacity: 0.6;
}
```

#### Secondary Button
```jsx
<button className="btn btn-secondary">
  Action Text
</button>

/* CSS */
.btn-secondary {
  background-color: #F0F2F5;
  color: #1C1E21;
  border: 1px solid #E0E0E0;
}

.btn-secondary:hover {
  background-color: #E9E9EB;
  border-color: #CCCCCC;
}
```

#### Outline Button
```jsx
<button className="btn btn-outline">
  Action Text
</button>

/* CSS */
.btn-outline {
  background-color: transparent;
  color: #0084FF;
  border: 1px solid #0084FF;
}

.btn-outline:hover {
  background-color: rgba(0, 132, 255, 0.1);
  border-color: #0073E6;
}
```

#### Icon Button
```jsx
<button className="btn-icon" aria-label="Menu">
  <MenuIcon size={22} />
</button>

/* CSS */
.btn-icon {
  width: 40px;
  height: 40px;
  padding: 0;
  border-radius: 8px;
  border: none;
  background-color: transparent;
  color: #1C1E21;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s ease;
}

.btn-icon:hover {
  background-color: #F0F2F5;
}
```

#### Action Button (with Icon + Label)
```jsx
<button className="btn-action">
  <UploadIcon size={16} />
  <span>Xuất excel</span>
</button>

/* CSS */
.btn-action {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background-color: transparent;
  border: 1px solid #E0E0E0;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  color: #1C1E21;
  transition: all 0.2s ease;
}

.btn-action:hover {
  border-color: #0084FF;
  color: #0084FF;
  background-color: rgba(0, 132, 255, 0.05);
}
```

---

### 2. Form Elements

#### Text Input
```jsx
<div className="form-group">
  <label htmlFor="search" className="label">Tìm khách hàng</label>
  <input
    id="search"
    type="text"
    className="input"
    placeholder="Nhập tìm kiếm..."
  />
</div>

/* CSS */
.form-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-bottom: 12px;
}

.label {
  font-size: 13px;
  font-weight: 500;
  color: var(--color-text-primary);
}

.input {
  padding: 10px 12px;
  font-size: 13px;
  border: 1px solid var(--color-divider);
  border-radius: 8px;
  background-color: var(--color-input-bg);
  color: var(--color-text-primary);
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.input:focus {
  outline: none;
  border-color: var(--color-primary-blue);
  box-shadow: 0 0 0 3px rgba(0, 132, 255, 0.1);
  background-color: #FFFFFF;
}

.input::placeholder {
  color: #999999;
}
```

#### Search Input with Icon
```jsx
<div className="search-field">
  <SearchIcon size={18} className="search-icon" />
  <input
    type="text"
    className="input-with-icon"
    placeholder="Tìm khách hàng"
  />
</div>

/* CSS */
.search-field {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: 12px;
  color: #999999;
  pointer-events: none;
}

.input-with-icon {
  padding-left: 36px;
  padding-right: 12px;
}
```

#### Dropdown/Select
```jsx
<div className="dropdown">
  <div className="dropdown-trigger">
    <span>Test Station</span>
    <ExpandMoreIcon size={16} />
  </div>
  {/* Dropdown menu items */}
</div>

/* CSS */
.dropdown-trigger {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  border: 1px solid #0084FF;
  border-radius: 8px;
  background-color: #FFFFFF;
  cursor: pointer;
  gap: 8px;
}

.dropdown-trigger:hover {
  background-color: rgba(0, 132, 255, 0.05);
}

.dropdown-menu {
  position: absolute;
  background-color: #FFFFFF;
  border: 1px solid var(--color-divider);
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 1000;
  min-width: 200px;
}

.dropdown-item {
  padding: 10px 12px;
  cursor: pointer;
  transition: background-color 0.2s ease;
  font-size: 13px;
  color: var(--color-text-primary);
}

.dropdown-item:hover {
  background-color: var(--color-input-bg);
}
```

#### Checkbox
```jsx
<div className="checkbox">
  <input
    id="agree"
    type="checkbox"
    className="checkbox-input"
  />
  <label htmlFor="agree" className="checkbox-label">
    I agree to terms
  </label>
</div>

/* CSS */
.checkbox-input {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: var(--color-primary-blue);
}

.checkbox-label {
  margin-left: 8px;
  font-size: 13px;
  color: var(--color-text-primary);
  cursor: pointer;
}
```

---

### 3. Cards & Containers

#### Card Component
```jsx
<div className="card">
  <div className="card-header">
    <h3>Card Title</h3>
    <button className="btn-icon">...</button>
  </div>
  <div className="card-body">
    Content here
  </div>
  <div className="card-footer">
    Footer actions
  </div>
</div>

/* CSS */
.card {
  background-color: #FFFFFF;
  border: 1px solid var(--color-divider);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  transition: box-shadow 0.2s ease;
}

.card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  border-bottom: 1px solid var(--color-divider);
}

.card-body {
  padding: 16px;
}

.card-footer {
  padding: 12px 16px;
  border-top: 1px solid var(--color-divider);
  background-color: var(--color-input-bg);
  display: flex;
  gap: 8px;
  justify-content: flex-end;
}
```

#### Status Badge
```jsx
<span className="badge badge-success">Active</span>
<span className="badge badge-warning">Pending</span>
<span className="badge badge-error">Blocked</span>

/* CSS */
.badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 8px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 600;
  white-space: nowrap;
}

.badge-success {
  background-color: rgba(49, 162, 76, 0.1);
  color: #31A24C;
}

.badge-warning {
  background-color: rgba(255, 149, 0, 0.1);
  color: #FF9500;
}

.badge-error {
  background-color: rgba(228, 22, 58, 0.1);
  color: #E4163A;
}
```

#### Alert / Message Box
```jsx
<div className="alert alert-info">
  <AlertIcon size={16} />
  <p>This is an informational message</p>
</div>

/* CSS */
.alert {
  display: flex;
  gap: 12px;
  align-items: flex-start;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 13px;
  line-height: 1.5;
}

.alert-info {
  background-color: rgba(0, 132, 255, 0.1);
  color: #0084FF;
  border-left: 3px solid #0084FF;
}

.alert-success {
  background-color: rgba(49, 162, 76, 0.1);
  color: #31A24C;
  border-left: 3px solid #31A24C;
}

.alert-error {
  background-color: rgba(228, 22, 58, 0.1);
  color: #E4163A;
  border-left: 3px solid #E4163A;
}
```

---

### 4. Message Bubbles (Chat)

#### Message Bubble
```jsx
<div className="message-group">
  <div className="message-bubble message-received">
    <div className="message-sender">John Doe</div>
    <p className="message-text">This is a received message</p>
    <div className="message-time">10:30 AM</div>
  </div>

  <div className="message-bubble message-sent">
    <p className="message-text">This is a sent message</p>
    <div className="message-time">10:31 AM</div>
  </div>
</div>

/* CSS */
.message-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 16px;
}

.message-bubble {
  display: inline-flex;
  flex-direction: column;
  gap: 4px;
  padding: 10px 14px;
  border-radius: 8px;
  max-width: 68%;
  word-wrap: break-word;
}

.message-received {
  align-self: flex-start;
  background-color: var(--color-bubble-grey);
  color: var(--color-text-primary);
  border-bottom-left-radius: 0;
}

.message-sent {
  align-self: flex-end;
  background-color: var(--color-primary-blue);
  color: #FFFFFF;
  border-bottom-right-radius: 0;
}

.message-sender {
  font-size: 11px;
  font-weight: 500;
  color: #999999;
  margin-bottom: 2px;
}

.message-text {
  font-size: 14px;
  line-height: 1.4;
  margin: 0;
}

.message-time {
  font-size: 11px;
  opacity: 0.7;
  margin-top: 2px;
}
```

---

### 5. Tab Navigation

#### Tabs Component
```jsx
<div className="tabs">
  <div className="tab-list">
    <button className="tab-button tab-active">Tab 1</button>
    <button className="tab-button">Tab 2</button>
    <button className="tab-button">Tab 3</button>
  </div>
  <div className="tab-content">
    {/* Content for active tab */}
  </div>
</div>

/* CSS */
.tabs {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.tab-list {
  display: flex;
  border-bottom: 1px solid var(--color-divider);
  background-color: #FFFFFF;
  gap: 0;
}

.tab-button {
  flex: 1;
  padding: 12px 16px;
  background-color: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  color: #666666;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.tab-button:hover {
  color: var(--color-text-primary);
}

.tab-button.tab-active {
  color: var(--color-primary-blue);
  border-bottom-color: var(--color-primary-blue);
}

.tab-content {
  padding: 12px;
}
```

---

### 6. Modals & Overlays

#### Modal Dialog
```jsx
<div className="modal-overlay">
  <div className="modal">
    <div className="modal-header">
      <h2>Dialog Title</h2>
      <button className="btn-close">×</button>
    </div>
    <div className="modal-body">
      Dialog content here
    </div>
    <div className="modal-footer">
      <button className="btn btn-secondary">Cancel</button>
      <button className="btn btn-primary">Confirm</button>
    </div>
  </div>
</div>

/* CSS */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.modal {
  background-color: #FFFFFF;
  border-radius: 12px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  max-width: 500px;
  width: 90%;
  overflow: hidden;
  animation: slideUp 0.3s ease;
}

@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px;
  border-bottom: 1px solid var(--color-divider);
}

.btn-close {
  width: 32px;
  height: 32px;
  padding: 0;
  background-color: transparent;
  border: none;
  font-size: 24px;
  color: #999999;
  cursor: pointer;
}

.btn-close:hover {
  color: var(--color-text-primary);
}

.modal-body {
  padding: 16px;
}

.modal-footer {
  padding: 12px 16px;
  border-top: 1px solid var(--color-divider);
  background-color: var(--color-input-bg);
  display: flex;
  gap: 8px;
  justify-content: flex-end;
}
```

#### Bottom Sheet
```jsx
<div className="bottom-sheet-overlay">
  <div className="bottom-sheet">
    <div className="sheet-handle"></div>
    <div className="sheet-header">
      <h2>Sheet Title</h2>
    </div>
    <div className="sheet-content">
      Content here
    </div>
  </div>
</div>

/* CSS */
.bottom-sheet-overlay {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.3);
  z-index: 1000;
}

.bottom-sheet {
  background-color: #FFFFFF;
  border-radius: 16px 16px 0 0;
  max-height: 80vh;
  overflow-y: auto;
  animation: slideUpSheet 0.3s ease;
}

@keyframes slideUpSheet {
  from { transform: translateY(100%); }
  to { transform: translateY(0); }
}

.sheet-handle {
  width: 40px;
  height: 4px;
  background-color: #CCCCCC;
  border-radius: 2px;
  margin: 12px auto;
}

.sheet-header {
  padding: 16px;
  border-bottom: 1px solid var(--color-divider);
}

.sheet-content {
  padding: 16px;
}
```

---

### 7. Data Table / List

#### Responsive Table
```jsx
<div className="table-container">
  <table className="data-table">
    <thead>
      <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Status</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>John Doe</td>
        <td>john@example.com</td>
        <td><span className="badge badge-success">Active</span></td>
        <td>
          <button className="btn-icon btn-sm">Edit</button>
          <button className="btn-icon btn-sm btn-danger">Delete</button>
        </td>
      </tr>
    </tbody>
  </table>
</div>

/* CSS */
.table-container {
  overflow-x: auto;
  border: 1px solid var(--color-divider);
  border-radius: 8px;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.data-table thead {
  background-color: var(--color-input-bg);
  border-bottom: 1px solid var(--color-divider);
}

.data-table th {
  padding: 12px 16px;
  text-align: left;
  font-weight: 600;
  color: var(--color-text-primary);
}

.data-table td {
  padding: 12px 16px;
  border-bottom: 1px solid var(--color-divider);
  color: var(--color-text-primary);
}

.data-table tr:hover {
  background-color: var(--color-input-bg);
}
```

---

## 🏗️ Architecture & React Components

### Directory Structure (Recommended)
```
src/
├── components/
│   ├── common/
│   │   ├── Button/
│   │   │   ├── Button.jsx
│   │   │   ├── Button.module.css
│   │   │   └── Button.stories.jsx
│   │   ├── Badge/
│   │   ├── Card/
│   │   ├── Modal/
│   │   ├── Alert/
│   │   └── ...
│   ├── form/
│   │   ├── TextField/
│   │   ├── Select/
│   │   ├── Checkbox/
│   │   └── ...
│   ├── layout/
│   │   ├── Navbar/
│   │   ├── Sidebar/
│   │   ├── MainLayout/
│   │   └── ...
│   └── features/
│       ├── TicketList/
│       ├── TicketDetail/
│       ├── CustomerManagement/
│       └── ...
├── styles/
│   ├── colors.css
│   ├── typography.css
│   ├── spacing.css
│   ├── globals.css
│   └── variables.css
├── utils/
│   ├── classNames.js
│   └── ...
└── pages/
    ├── TicketsPage.jsx
    ├── CustomersPage.jsx
    └── ...
```

### Component Composition Pattern

**Base Component (Button.jsx)**
```jsx
import React from 'react';
import styles from './Button.module.css';

const Button = ({
  variant = 'primary', // primary | secondary | outline
  size = 'md', // sm | md | lg
  children,
  icon: Icon = null,
  disabled = false,
  className = '',
  ...props
}) => {
  const buttonClass = [
    styles.btn,
    styles[`btn-${variant}`],
    styles[`btn-${size}`],
    disabled && styles.disabled,
    className,
  ].filter(Boolean).join(' ');

  return (
    <button className={buttonClass} disabled={disabled} {...props}>
      {Icon && <Icon size={16} />}
      {children}
    </button>
  );
};

export default Button;
```

**Button Module CSS (Button.module.css)**
```css
.btn {
  padding: 10px 16px;
  border-radius: 8px;
  border: none;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.btn-primary {
  background-color: var(--color-primary-blue);
  color: #FFFFFF;
}

.btn-primary:hover:not(.disabled) {
  background-color: #0073E6;
  box-shadow: 0 2px 8px rgba(0, 132, 255, 0.3);
}

.btn-secondary {
  background-color: var(--color-input-bg);
  color: var(--color-text-primary);
  border: 1px solid var(--color-divider);
}

.btn-outline {
  background-color: transparent;
  color: var(--color-primary-blue);
  border: 1px solid var(--color-primary-blue);
}

.btn-sm {
  padding: 6px 12px;
  font-size: 12px;
}

.btn-lg {
  padding: 12px 20px;
  font-size: 16px;
}

.disabled {
  background-color: #CCCCCC !important;
  cursor: not-allowed;
  opacity: 0.6;
}
```

### Reusable Hook Pattern

**useTheme Hook**
```js
// hooks/useTheme.js
export const useTheme = () => {
  return {
    colors: {
      primary: '#0084FF',
      primaryPurple: '#5E5CE6',
      darkBlue: '#0D1B3E',
      bgGrey: '#F8F9FD',
      textPrimary: '#1C1E21',
      inputBg: '#F0F2F5',
      bubbleGrey: '#E9E9EB',
      divider: '#E0E0E0',
      successGreen: '#31A24C',
      warningOrange: '#FF9500',
      errorRed: '#E4163A',
    },
    spacing: {
      xs: '4px',
      sm: '8px',
      md: '12px',
      lg: '16px',
      xl: '20px',
      '2xl': '24px',
      '3xl': '32px',
    },
    typography: {
      h1: { fontSize: '20px', fontWeight: 700, lineHeight: 1.4 },
      h2: { fontSize: '18px', fontWeight: 700, lineHeight: 1.3 },
      body: { fontSize: '14px', fontWeight: 400, lineHeight: 1.5 },
      caption: { fontSize: '12px', fontWeight: 400, lineHeight: 1.4 },
    },
  };
};
```

### Utility Class Helper

**classNames Utility**
```js
// utils/classNames.js
export const classNames = (...classes) => {
  return classes.filter(Boolean).join(' ');
};

// Usage in components
const buttonClass = classNames(
  styles.btn,
  variant === 'primary' && styles['btn-primary'],
  size === 'lg' && styles['btn-lg'],
  disabled && styles.disabled,
);
```

---

## 💡 Implementation Examples

### Example 1: Ticket List Component

```jsx
// components/features/TicketList/TicketList.jsx
import React, { useState } from 'react';
import Button from '../../common/Button';
import Badge from '../../common/Badge';
import TextField from '../../form/TextField';
import styles from './TicketList.module.css';

const TicketList = ({ tickets = [] }) => {
  const [searchQuery, setSearchQuery] = useState('');

  const filteredTickets = tickets.filter(ticket =>
    ticket.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
    ticket.title.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const getStatusColor = (status) => {
    const statusColorMap = {
      open: 'info',
      'in-progress': 'warning',
      resolved: 'success',
      closed: 'error',
    };
    return statusColorMap[status] || 'info';
  };

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <h1>Danh sách phiếu hỗ trợ</h1>
        <Button variant="primary">+ Tạo phiếu mới</Button>
      </div>

      <div className={styles.searchBar}>
        <TextField
          type="search"
          placeholder="Tìm phiếu..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
        />
      </div>

      <div className={styles.ticketList}>
        {filteredTickets.map((ticket) => (
          <div key={ticket.id} className={styles.ticketCard}>
            <div className={styles.ticketHeader}>
              <h3>{ticket.id}</h3>
              <Badge variant={getStatusColor(ticket.status)}>
                {ticket.status}
              </Badge>
            </div>
            <p className={styles.ticketTitle}>{ticket.title}</p>
            <div className={styles.ticketMeta}>
              <span>{ticket.customer}</span>
              <span>{ticket.agent || 'Unassigned'}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default TicketList;
```

**TicketList.module.css**
```css
.container {
  padding: 16px;
  background-color: var(--color-bg-grey);
  min-height: 100vh;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.header h1 {
  font-size: 20px;
  font-weight: 700;
  color: var(--color-text-primary);
  margin: 0;
}

.searchBar {
  margin-bottom: 20px;
}

.ticketList {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 12px;
}

.ticketCard {
  background-color: #FFFFFF;
  border: 1px solid var(--color-divider);
  border-radius: 8px;
  padding: 12px;
  cursor: pointer;
  transition: box-shadow 0.2s ease;
}

.ticketCard:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.ticketHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.ticketHeader h3 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: var(--color-text-primary);
}

.ticketTitle {
  margin: 0 0 8px 0;
  font-size: 13px;
  color: var(--color-text-primary);
  line-height: 1.4;
}

.ticketMeta {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #999999;
}
```

---

### Example 2: Modal Confirmation

```jsx
// components/common/ConfirmDialog/ConfirmDialog.jsx
import React from 'react';
import Button from '../Button';
import styles from './ConfirmDialog.module.css';

const ConfirmDialog = ({
  open = false,
  title = 'Confirm',
  message = 'Are you sure?',
  onConfirm,
  onCancel,
  confirmText = 'Confirm',
  cancelText = 'Cancel',
}) => {
  if (!open) return null;

  return (
    <div className={styles.overlay}>
      <div className={styles.modal}>
        <h2>{title}</h2>
        <p>{message}</p>
        <div className={styles.actions}>
          <Button variant="secondary" onClick={onCancel}>
            {cancelText}
          </Button>
          <Button variant="primary" onClick={onConfirm}>
            {confirmText}
          </Button>
        </div>
      </div>
    </div>
  );
};

export default ConfirmDialog;
```

---

## 📌 Key Design Principles

1. **Consistency**: Use the same colors, spacing, and typography across all features
2. **Hierarchy**: Clear visual hierarchy through typography and spacing
3. **Accessibility**: Proper contrast ratios, semantic HTML, ARIA labels
4. **Responsiveness**: Mobile-first approach, progressive enhancement
5. **User Feedback**: Hover/active states, loading states, error handling
6. **Performance**: CSS modules, lazy loading, optimized assets

---

## 🚀 Getting Started Checklist

- [ ] Set up CSS variables in `styles/variables.css`
- [ ] Create base components (Button, Badge, Card, etc.)
- [ ] Build form components (TextField, Select, etc.)
- [ ] Implement layout components (Navbar, Sidebar)
- [ ] Create feature-specific components (TicketList, etc.)
- [ ] Add responsive media queries
- [ ] Test accessibility (keyboard navigation, screen readers)
- [ ] Document components with Storybook

---

**Last Updated**: March 16, 2026  
**System**: Jarvis Helpdesk  
**Framework**: React (CSR)  
**Base Colors**: Messenger Blue + Material Design
