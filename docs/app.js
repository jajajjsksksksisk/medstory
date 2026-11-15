// MedStory – simple mobile web app (localStorage)
// Works on iPhone / iPad Safari without any computer

const SUBJECTS = ["Anatomy","Physiology","Biochemistry","Pathology","Pharmacology","Microbiology","Medicine","Surgery","Pediatrics","Obstetrics & Gynaecology","Other"];

function load(key, fallback) {
  try {
    return JSON.parse(localStorage.getItem(key)) || fallback;
  } catch {
    return fallback;
  }
}
function save(key, value) {
  localStorage.setItem(key, JSON.stringify(value));
}

function uid() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
}

// ---------- Simple spaced repetition (inspired by SM-2 / FSRS ideas) ----------
function scheduleCard(card, rating) {
  // rating: 1 Again, 2 Hard, 3 Good, 4 Easy
  const now = Date.now();
  let interval = card.interval || 0; // days
  let ease = card.ease || 2.5;

  if (rating === 1) {
    interval = 0;
    ease = Math.max(1.3, ease - 0.2);
    card.lapses = (card.lapses || 0) + 1;
  } else if (rating === 2) {
    interval = Math.max(1, Math.round(interval * 1.2));
    ease = Math.max(1.3, ease - 0.15);
  } else if (rating === 3) {
    interval = interval === 0 ? 1 : Math.round(interval * ease);
  } else {
    interval = interval === 0 ? 3 : Math.round(interval * ease * 1.3);
    ease = ease + 0.15;
  }

  card.interval = interval;
  card.ease = ease;
  card.reps = (card.reps || 0) + 1;
  card.due = now + interval * 24 * 60 * 60 * 1000;
  card.lastReview = now;
  return card;
}

function getDueCards() {
  const cards = load("cards", []);
  const now = Date.now();
  return cards.filter(c => !c.due || c.due <= now);
}

// ---------- Generate study material from pasted text (offline) ----------
function generateFromNotes() {
  const text = document.getElementById("notes").value.trim();
  const subject = document.getElementById("subject").value;
  const topic = document.getElementById("topic").value.trim();

  if (!text) {
    alert("Please paste some notes first.");
    return;
  }

  const btn = document.getElementById("btn-generate");
  btn.disabled = true;
  btn.textContent = "Generating…";

  // Split into lines / sentences for simple flashcards
  const lines = text
    .split(/[\n\.]+/)
    .map(s => s.trim())
    .filter(s => s.length > 20 && s.length < 300);

  const cards = [];
  const maxCards = Math.min(12, Math.max(3, lines.length));
  for (let i = 0; i < maxCards; i++) {
    const line = lines[i] || text.slice(i * 40, i * 40 + 80);
    cards.push({
      id: uid(),
      front: `Key point ${i + 1} (${subject}${topic ? " – " + topic : ""})?`,
      back: line,
      subject,
      topic: topic || null,
      due: Date.now(),
      interval: 0,
      ease: 2.5,
      reps: 0,
      lapses: 0,
    });
  }

  // Summary = first ~8 substantial lines
  const summaryLines = lines.slice(0, 8).map(l => "• " + l);
  const summary = summaryLines.join("\n") || "• " + text.slice(0, 400);

  // Last-day notes = shorter
  const lastDay = lines.slice(0, 5).map(l => "• " + l).join("\n") ||
    "• Review the main points from your notes\n• Focus on definitions and lists";

  // Simple story
  const story = {
    id: uid(),
    title: topic || subject + " story",
    concept: topic || subject,
    subject,
    topic: topic || null,
    storyText:
      `Imagine walking through a quiet hospital corridor the night before your ${subject} exam.\n\n` +
      `On the walls you see the key facts from your notes:\n\n` +
      lines.slice(0, 4).map((l, i) => `${i + 1}. ${l}`).join("\n") +
      `\n\nYou walk past each one slowly. By the time you reach the end of the corridor, they stay in your memory.`,
    createdAt: Date.now(),
  };

  const note = {
    id: uid(),
    title: topic || (subject + " notes"),
    subject,
    topic: topic || null,
    summary,
    lastDayNotes: lastDay,
    createdAt: Date.now(),
  };

  // Save
  const allCards = load("cards", []);
  allCards.push(...cards);
  save("cards", allCards);

  const allNotes = load("notes", []);
  allNotes.unshift(note);
  save("notes", allNotes);

  const allStories = load("stories", []);
  allStories.unshift(story);
  save("stories", allStories);

  btn.disabled = false;
  btn.textContent = "Generate Summary + Cards";

  alert(`Done!\n\n• ${cards.length} flashcards\n• 1 summary + last-day notes\n• 1 story\n\nGo to Review to study.`);
  document.getElementById("notes").value = "";
  refreshStats();
  showPage("home");
}

// ---------- Review ----------
let reviewQueue = [];
let reviewIndex = 0;

function startReview() {
  reviewQueue = getDueCards();
  reviewIndex = 0;
  const empty = document.getElementById("review-empty");
  const box = document.getElementById("review-box");

  if (reviewQueue.length === 0) {
    empty.classList.remove("hidden");
    box.classList.add("hidden");
    return;
  }
  empty.classList.add("hidden");
  box.classList.remove("hidden");
  showCurrentCard();
}

function showCurrentCard() {
  if (reviewIndex >= reviewQueue.length) {
    document.getElementById("review-empty").textContent = "All caught up for now. Great work!";
    document.getElementById("review-empty").classList.remove("hidden");
    document.getElementById("review-box").classList.add("hidden");
    refreshStats();
    return;
  }
  const c = reviewQueue[reviewIndex];
  document.getElementById("review-subject").textContent = c.subject + (c.topic ? " • " + c.topic : "");
  document.getElementById("review-front").textContent = c.front;
  document.getElementById("review-back").textContent = c.back;
  document.getElementById("review-back").classList.add("hidden");
  document.getElementById("btn-show").classList.remove("hidden");
  document.getElementById("rating-row").classList.add("hidden");
}

function showAnswer() {
  document.getElementById("review-back").classList.remove("hidden");
  document.getElementById("btn-show").classList.add("hidden");
  document.getElementById("rating-row").classList.remove("hidden");
}

function rate(rating) {
  const c = reviewQueue[reviewIndex];
  const updated = scheduleCard({ ...c }, rating);
  const all = load("cards", []);
  const idx = all.findIndex(x => x.id === c.id);
  if (idx >= 0) all[idx] = updated;
  save("cards", all);
  reviewIndex++;
  showCurrentCard();
  refreshStats();
}

// ---------- Lists ----------
function renderLastDay() {
  const notes = load("notes", []).filter(n => n.lastDayNotes);
  const el = document.getElementById("lastday-list");
  if (notes.length === 0) {
    el.innerHTML = `<div class="empty">No last-day notes yet.<br>Upload notes to create them.</div>`;
    return;
  }
  el.innerHTML = notes.map(n => `
    <div class="card">
      <span class="badge">${n.subject}</span>
      <h2>${escapeHtml(n.title)}</h2>
      <pre class="story-text" style="margin-top:10px">${escapeHtml(n.lastDayNotes)}</pre>
    </div>
  `).join("");
}

function renderStories() {
  const stories = load("stories", []);
  const el = document.getElementById("stories-list");
  if (stories.length === 0) {
    el.innerHTML = `<div class="empty">No stories yet.<br>Upload notes to generate mnemonics.</div>`;
    return;
  }
  el.innerHTML = stories.map(s => `
    <div class="card">
      <span class="badge">${s.subject}</span>
      <h2>${escapeHtml(s.title)}</h2>
      <p style="margin:6px 0;font-style:italic">${escapeHtml(s.concept || "")}</p>
      <div class="story-text">${escapeHtml(s.storyText)}</div>
    </div>
  `).join("");
}

function renderCards() {
  const cards = load("cards", []);
  const el = document.getElementById("cards-list");
  if (cards.length === 0) {
    el.innerHTML = `<div class="empty">No flashcards yet.</div>`;
    return;
  }
  el.innerHTML = cards.map(c => `
    <div class="card">
      <span class="badge">${c.subject}</span>
      <h2 style="font-size:0.95rem">${escapeHtml(c.front)}</h2>
      <p style="margin-top:8px">${escapeHtml(c.back)}</p>
    </div>
  `).join("");
}

function escapeHtml(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function refreshStats() {
  document.getElementById("stat-due").textContent = getDueCards().length;
  document.getElementById("stat-cards").textContent = load("cards", []).length;
  document.getElementById("stat-notes").textContent = load("notes", []).length;
}

// ---------- Navigation ----------
function showPage(name) {
  ["home", "upload", "review", "lastday", "stories", "cards"].forEach(p => {
    const el = document.getElementById("page-" + p);
    if (el) el.classList.toggle("hidden", p !== name);
  });
  document.querySelectorAll(".nav button").forEach(b => b.classList.remove("active"));
  // highlight roughly
  if (name === "home") document.querySelectorAll(".nav button")[0]?.classList.add("active");
  if (name === "upload") document.querySelectorAll(".nav button")[1]?.classList.add("active");
  if (name === "review") document.querySelectorAll(".nav button")[2]?.classList.add("active");
  if (name === "lastday") document.querySelectorAll(".nav button")[3]?.classList.add("active");
  if (name === "stories") document.querySelectorAll(".nav button")[4]?.classList.add("active");

  if (name === "review") startReview();
  if (name === "lastday") renderLastDay();
  if (name === "stories") renderStories();
  if (name === "cards") renderCards();
  if (name === "home") refreshStats();
}

refreshStats();
