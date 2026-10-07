---
name: match-my-writing-style
description: Learns your voice from your real writing
---

# Match My Writing Style

On first activation, scans your workspace to build a Voice Card doc from your real writing — sentence length, vocabulary, tone, openings, closings, quirks, and channel-specific registers. The card is saved and every future draft uses it. No re-scanning, no repeated setup.

## When to Use

This skill is **always on**. It triggers any time the agent produces written output for the user, including but not limited to:

- The user asks to write, draft, compose, or send anything
- The user asks to reply to an email, message, or thread
- The user asks for a summary, memo, announcement, or update
- The user asks to write a blog post, tweet, LinkedIn post, or doc
- The user says "match my voice," "write like me," or "sound like me"
- The user asks to clone their writing style or create a voice profile
- The user asks to see, review, or update their voice card
- The user wants to refine how the agent captures their writing patterns
- Any task where the output is text the user will send, publish, or share

**Default behavior:** If the user asks you to write anything and doesn't specify a voice or persona, use their Voice Card. The user's own voice is the default — not generic AI writing. The only exception is when the user explicitly asks for a different tone or persona (e.g., "write this in a formal legal tone" or "write as if you're a customer support bot").

## Onboarding: Build the Voice Card (one time only)

This step runs ONCE — the first time the skill is activated. Check Drive to see if a Voice Card already exists for this user, skip directly to "Draft in Voice".

### Scan the workspace

Automatically scan the user's workspace to find real examples of their writing. Do NOT ask the user for writing samples. Search across:

- **Sent emails** — Professional and personal. Prioritize recent (last 90 days) and diverse recipients (clients, team, executives, friends).
- **Docs and notes** — Documents the user authored (not commented on).
- **Chat messages** — Any chat history. Pull messages the user sent, not received.
- **Calendar descriptions** — How the user titles and describes meetings.

**What to collect:**

- 15-30 writing samples across at least 3 channels
- Prioritize variety: formal emails, casual messages, long-form writing, quick replies
- Tag each sample with channel and audience (e.g., "Email to client," "Chat to engineering team")

**If workspace access is limited:** Tell the user what you couldn't access and ask them to paste examples only from the missing channels. Don't ask for everything — ask only for what you can't find.

### Analyze and build the Voice Card

From the collected samples, extract:

- **Sentence length** — Short punchy bursts? Medium conversational? Long complex? Mixed for rhythm?
- **Vocabulary level** — Simple and direct ("use" not "utilize")? Technical? Audience-dependent?
- **Transition words** — What bridges do they use? ("But," "Here's the thing —," "So basically," "Look,")
- **Signature openings** — How they start emails, messages, docs (greeting style, opening move)
- **Signature closings** — Sign-off, P.S. habits, how they end posts
- **Rhetorical patterns** — Questions? Analogies? Data-first? Stories? Rule of three? Humor?
- **Tone markers** — Direct or hedging? Warm or clinical? Sarcastic or earnest? When does tone shift?
- **Paragraph structure** — Short paragraphs? Lists and bullets? Single-line emphasis?
- **Punctuation quirks** — Em dashes? Oxford commas? Exclamation points? ALL CAPS? Parentheticals?
- **Contractions & formality** — "don't" or "do not"? This is a massive voice signal.
- **Emoji & formatting** — Do they use emoji? Bold? Headers? How does this change by channel?
- **Channel registers** — How their voice shifts between email, chat, long-form, and casual. Most people have 2-3 distinct registers.

### Present the Voice Card for review

Show the Voice Card and ask three questions:

1. **"Words I never use"** — words that make them cringe. Ban list is absolute.
2. **"Phrases that sound like me"** — verbal fingerprints to preserve.
3. **"Anything I got wrong?"** — let them correct misreadings.

### Save the Voice Card

Once the user confirms (or edits), save the Voice Card in #memory. This card is now the source of truth for all future drafts. The workspace does not need to be re-scanned.

## Draft in Voice (every time after onboarding)

When the user asks you to write anything, use the saved Voice Card Doc:

1. **Identify the channel** — email, chat, blog, tweet, memo. If unclear, ask. The channel determines which register to use.
2. **Match the voice profile exactly** — sentence length, vocabulary, transitions, tone, paragraph structure, punctuation. All of it.
3. **Use their openings and closings** — don't invent new ones. Use patterns from their actual writing.
4. **Enforce the banned word list** — never use a word from their "never use" list. Substitute with what they would say.
5. **Flag deviations** — if any passage feels off-voice, flag it inline: "[⚠️ This doesn't sound like you — want me to rework?]"
6. **Never add formality they don't use** — if they write "Hey" not "Dear," so do you.
7. **Never strip personality they do use** — if they use humor, profanity, or emoji in a channel, so do you.

## Update the Voice Card (only when asked)

The Voice Card only changes when the user explicitly asks:

- **"Update my voice card"** — Re-scan the workspace for new writing samples and refresh the card. Show what changed.
- **"Add this to my voice card"** — User provides a new sample or correction. Update the relevant section.
- **Editing a draft** — When the user edits a draft you wrote, note what changed and offer to update the card: "You changed '[original]' to '[edited].' Want me to update your Voice Card to reflect this?"

Do NOT re-scan the workspace unprompted. Do NOT suggest Voice Card updates unless the user's edits reveal a clear pattern shift.

## Example

### First activation — "Match My Writing Style"

The agent scans the workspace: pulls 20+ sent emails, 3 authored docs, and recent chat messages. Builds a Voice Card and presents it: "You write short sentences. Heavy em-dash user. Start emails with 'Hey' or jump straight to the point — never 'Dear' or 'I hope this finds you well.' Closings are 'Best,' or nothing. Chat messages use lowercase, no punctuation, occasional emoji. Long-form writing is more structured but still conversational. Ban list: [none yet]. Sound right?"

### Every time after — "Draft a response to this investor email"

The agent pulls the saved Voice Card, identifies "email to investor" as the register, and writes the reply in the user's exact email voice — greeting, rhythm, sign-off — with zero workspace scanning.

### "Write a message to the team about the delay"

The agent switches to the Chat register from the Voice Card — casual, direct, lowercase, emoji if they use them — and produces a ready-to-send message.

## Gotchas

- The onboarding scan depends on what data sources are accessible — if email or chat is unavailable, the agent asks the user to fill gaps manually for those channels only
- Voice matching improves with feedback on drafts, but the user must explicitly approve changes to the Voice Card
- Cannot perfectly capture voice for formats the user hasn't written in (e.g., if they've never written a blog post, that register is approximated from similar long-form writing)
- The Voice Card does NOT auto-update. If the user's style evolves over months, they should say "update my voice card" to trigger a re-scan
