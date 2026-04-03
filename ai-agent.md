## Overview
Implement the full UI and offline flow for AI agent management and the chat playground using mock data.

## Scope (UI + Offline)

### AI Agent Management
- Create and configure AI agent screens
- Agent profile customization UI
- Agent behavior settings (auto vs semi-auto toggle)
- Team-level assistant configuration screen
- Multi-platform publishing selection UI (Slack, Telegram, Messenger)

### AI Chat Playground
- Interactive playground chat interface
- File upload UI (no actual processing)
- Context simulation selector (Lazada, normal customer)
- Markdown and image rendering in messages
- Message editing UI
- Session management (new session, session history)
- Typing indicator animation
- Response streaming simulation
- Empty state with suggestion chips

### Advanced Features UI
- Draft response suggestion panel for CS agents
- Workflow selection UI (min 3 workflow types)

## Acceptance Criteria
- [ ] Agent management CRUD screens implemented
- [ ] Playground chat interface with mock AI responses
- [ ] Streaming simulation works in playground
- [ ] File upload UI renders (no processing needed)
- [ ] Widget tree documented for each screen

## Notes
Focuses on UI fidelity and offline simulation only. No real AI/LLM calls.