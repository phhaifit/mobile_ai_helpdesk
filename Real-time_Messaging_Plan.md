## Detailed Implementation Plan: [Phase 1] Real-time Messaging

### 1. Overview & Objectives

Build a high-fidelity UI and offline simulation for the core messaging system of the **Mobile AI Helpdesk**. The focus is on UI accuracy, state management using the project's boilerplate standards, and simulating real-time interactions using mock data.

---

### 2. Architecture & Tech Stack

- **Framework:** Flutter
- **Architecture:** Clean Architecture (Data, Domain, UI)
- **State Management:** MobX (as per `flutter_boilerplate_project` structure)
- **Local Data:** Static JSON Mocking & `faker` library for dynamic-looking data.

---

### 3. Work Breakdown Structure (WBS)

#### Task 1: Data & Domain Layer (Mocking Logic)

- **Entities & Models:** Define `Message`, `Conversation`, `User`, and `Reaction` models.
- **Repository Interface:** Define `ChatRepository` in the domain layer.
- **Mock Implementation:** Implement `MockChatRepository` in the data layer to fetch hardcoded data from local assets/constants.
- **Use Cases:** Implement `GetConversationList`, `GetMessagesByRoomId`, and `SendMockMessage`.

#### Task 2: UI Development (High Fidelity)

- **Conversation List Screen:**
  - Unified chat interface listing all active channels.
  - Badges for unread message counts and active status indicators.
  - Search bar UI to filter conversations.
- **Messaging Interface Screen:**
  - **Message Bubbles:** Distinct styles for Sender, Receiver, and System messages.
  - **Compose Bar:** Input field with attachment icons and a send button.
  - **Read Receipts:** UI indicators for "Sent", "Delivered", and "Read".
  - **Reaction UI:** Long-press menu to show message reactions (Emojis).
- **AI Support Features:**
  - **AI Ticket Analysis Panel:** A slide-in panel showing mocked AI insights (Sentiment, Ticket Priority).
  - **Typing Indicator:** A smooth animation simulating the "Agent/User is typing..." state.

#### Task 3: Offline Flow & Simulation

- **Search Logic:** Implement local search within the message history list using mock data.
- **Real-time Simulation:** Use `Future.delayed` to trigger a mock "auto-reply" 2 seconds after a user sends a message to simulate a live agent/AI.
- **Navigation:** Integrate deep linking/routing from the main dashboard to the Chat Room.

---
