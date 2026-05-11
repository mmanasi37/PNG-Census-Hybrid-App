from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    HRFlowable, Preformatted
)
from reportlab.lib.enums import TA_CENTER, TA_LEFT

OUTPUT = "/home/mekere/Documents/Projects/Census Hybrid App/PNG_Census_2025_App_Summary.pdf"

doc = SimpleDocTemplate(
    OUTPUT,
    pagesize=A4,
    leftMargin=2*cm, rightMargin=2*cm,
    topMargin=2*cm, bottomMargin=2*cm,
    title="PNG Census 2025 — App Summary & Architecture",
    author="PNG Census Engineering"
)

styles = getSampleStyleSheet()

# Custom styles
h1 = ParagraphStyle("H1", parent=styles["Heading1"],
    fontSize=20, textColor=colors.HexColor("#283593"),
    spaceAfter=6, spaceBefore=0, leading=24)

h2 = ParagraphStyle("H2", parent=styles["Heading2"],
    fontSize=13, textColor=colors.HexColor("#3949AB"),
    spaceAfter=4, spaceBefore=14, leading=16,
    borderPad=2)

h3 = ParagraphStyle("H3", parent=styles["Heading3"],
    fontSize=11, textColor=colors.HexColor("#1A237E"),
    spaceAfter=3, spaceBefore=8)

body = ParagraphStyle("Body", parent=styles["Normal"],
    fontSize=9.5, leading=14, spaceAfter=4)

bullet = ParagraphStyle("Bullet", parent=styles["Normal"],
    fontSize=9.5, leading=13, leftIndent=14, spaceAfter=2,
    bulletIndent=4)

mono = ParagraphStyle("Mono", parent=styles["Code"],
    fontSize=7.5, leading=11, fontName="Courier",
    backColor=colors.HexColor("#F3F4F6"),
    borderColor=colors.HexColor("#C5CAE9"),
    borderWidth=0.5, borderPad=6,
    spaceAfter=8, spaceBefore=4)

caption = ParagraphStyle("Caption", parent=styles["Normal"],
    fontSize=8, textColor=colors.grey, alignment=TA_CENTER)

INDIGO = colors.HexColor("#3949AB")
LIGHT_INDIGO = colors.HexColor("#E8EAF6")
GREEN = colors.HexColor("#2E7D32")
ORANGE = colors.HexColor("#E65100")

story = []

# ── Title block ──────────────────────────────────────────────────────────────
story.append(Paragraph("PNG Census 2025", h1))
story.append(Paragraph("Hybrid Mobile App — Summary &amp; Architecture",
    ParagraphStyle("Sub", parent=styles["Normal"],
        fontSize=12, textColor=colors.HexColor("#5C6BC0"), spaceAfter=2)))
story.append(Paragraph("Flutter · Isar · Android/iOS · Offline-first · Bilingual EN/TPI",
    ParagraphStyle("Tags", parent=styles["Normal"],
        fontSize=8.5, textColor=colors.grey, spaceAfter=8)))
story.append(HRFlowable(width="100%", thickness=2, color=INDIGO, spaceAfter=12))

# ── Overview ─────────────────────────────────────────────────────────────────
story.append(Paragraph("Overview", h2))
story.append(Paragraph(
    "A fully offline-capable hybrid census data collection application built for Papua New Guinea "
    "field enumerators. The app runs on Android and iOS, stores all data locally using an embedded "
    "Isar database, supports bilingual (English / Tok Pisin) question display, and synchronises "
    "records to a central server whenever connectivity is available. A supervisor dashboard provides "
    "real-time progress visibility and conflict resolution.",
    body))

# ── Phase accomplishments ─────────────────────────────────────────────────────
story.append(Paragraph("Build Phases", h2))

phase_data = [
    ["Phase", "Deliverable"],
    ["1 — Environment &amp; Scaffold",
     "Project setup, dependencies, AndroidManifest permissions, asset structure"],
    ["2 — Data Layer",
     "Isar DB schema (HouseholdRecord, VectorClock embedded type), build_runner code generation"],
    ["3 — Form Engine",
     "ExpressionEvaluator (skip logic, 8 operators), ValidationResult, FormEngine ChangeNotifier, repeat-group answer management, hidden-answer pruning"],
    ["4 — Enumeration UI",
     "Tabbed section navigation, progress bar, bilingual toggle, GPS capture (Haversine geofence), camera/gallery image picker, audio question prompts, searchable option sheet (DraggableScrollableSheet)"],
    ["5 — Sync &amp; Translation",
     "Vector-clock conflict resolution, HTTP sync engine, Claude Haiku translation fallback (3-tier: glossary → cache → API), WorkManager 15-min background sync"],
    ["6 — Supervisor Dashboard",
     "Progress stats by status, conflict queue, conflict detail screen with approve / return-to-draft actions"],
]

phase_table = Table(phase_data, colWidths=[4.5*cm, 12.5*cm])
phase_table.setStyle(TableStyle([
    ("BACKGROUND",    (0,0), (-1,0),  INDIGO),
    ("TEXTCOLOR",     (0,0), (-1,0),  colors.white),
    ("FONTNAME",      (0,0), (-1,0),  "Helvetica-Bold"),
    ("FONTSIZE",      (0,0), (-1,0),  9),
    ("FONTSIZE",      (0,1), (-1,-1), 8.5),
    ("BACKGROUND",    (0,1), (-1,-1), colors.white),
    ("ROWBACKGROUNDS",(0,1), (-1,-1), [colors.white, LIGHT_INDIGO]),
    ("VALIGN",        (0,0), (-1,-1), "TOP"),
    ("GRID",          (0,0), (-1,-1), 0.4, colors.HexColor("#C5CAE9")),
    ("LEFTPADDING",   (0,0), (-1,-1), 6),
    ("RIGHTPADDING",  (0,0), (-1,-1), 6),
    ("TOPPADDING",    (0,0), (-1,-1), 5),
    ("BOTTOMPADDING", (0,0), (-1,-1), 5),
    ("FONTNAME",      (0,1), (0,-1),  "Helvetica-Bold"),
    ("TEXTCOLOR",     (0,1), (0,-1),  INDIGO),
]))
story.append(phase_table)

# ── Architecture ──────────────────────────────────────────────────────────────
story.append(Paragraph("Architecture", h2))
story.append(Paragraph(
    "The app is structured in four layers. Each layer depends only on layers below it; "
    "the UI never accesses the database directly.",
    body))

layers = [
    ("UI Layer", INDIGO, [
        "EnumerationScreen — tabbed form with TabController / TabBarView, ListenableBuilder for efficient rebuilds",
        "SupervisorScreen — DefaultTabController, two tabs with AutomaticKeepAliveClientMixin",
        "ConflictDetailScreen — orange-themed read-only record view with approve / return actions",
        "QuestionWidget — routes by QuestionType; custom _RadioTile, _OptionSheet (search for >7 options), GpsCaptureWidget, AudioPlayButton",
        "RepeatGroupWidget — expandable household roster cards with per-instance skip logic",
    ]),
    ("Form Engine", colors.HexColor("#1565C0"), [
        "FormEngine extends ChangeNotifier — single source of truth for all answers",
        "ExpressionEvaluator — evaluates showWhen conditions (eq/neq/gt/lt/gte/lte/contains/empty/notEmpty)",
        "Answer pruning — _pruneHidden() clears answers for newly-hidden questions on every setAnswer()",
        "exportAnswers() — merges flat + repeat-group answers into one Map<String, dynamic>",
        "completionPercent / isSectionComplete() — drives progress bar and tab checkmarks",
        "toggleLocale() — switches between EN and TPI, triggers full UI rebuild",
    ]),
    ("Data Layer", GREEN, [
        "IsarService (singleton) — wraps Isar 3.1, exposes typed CRUD helpers",
        "HouseholdRecord @collection — uuid (unique index), enumeratorId, status, answersJson (JSON blob), VectorClock",
        "VectorClock @embedded — two parallel lists (nodeIds, counters); increment(), merge(), happensBefore(), isConcurrentWith()",
        "RecordStatus enum — draft | complete | synced | conflict",
        "FormSchema — loaded from assets/schemas/png_census_2025.json; 3 sections, 43 questions total (incl. 22 roster sub-questions)",
    ]),
    ("Sync Layer", ORANGE, [
        "SyncEngine (singleton) — uploads complete/conflict records, fetches remote, resolves with ConflictResolver",
        "ConflictResolver — VectorClock comparison: if A happensBefore B → B wins; if concurrent → LWW merge, status = conflict",
        "TranslationService — 3-tier: built-in glossary (80 terms) → file-backed JSON cache → Claude Haiku API with prompt-caching beta header",
        "BackgroundSync — WorkManager periodic task (15 min, network-gated, exponential backoff); platform-guarded for Android/iOS only",
        "connectivity_plus — network state listener triggers immediate one-shot sync on reconnection",
    ]),
]

for layer_name, color, points in layers:
    story.append(Paragraph(layer_name, h3))
    for p in points:
        story.append(Paragraph(f"• {p}", bullet))
    story.append(Spacer(1, 4))

# ── Architecture diagram ──────────────────────────────────────────────────────
story.append(Paragraph("Layer Diagram", h2))
arch = """\
┌─────────────────────────────────────────────────────────┐
│                      Flutter UI Layer                   │
│  EnumerationScreen          SupervisorScreen            │
│  ├─ TabBar (Sections A/B/C) ├─ ProgressView             │
│  ├─ QuestionWidget          ├─ ConflictQueueView         │
│  ├─ RepeatGroupWidget       └─ ConflictDetailScreen      │
│  ├─ GpsCaptureWidget                                    │
│  └─ AudioPlayButton / OptionSheet                       │
└───────────────┬─────────────────────────────────────────┘
                │ ListenableBuilder
┌───────────────▼─────────────────────────────────────────┐
│              FormEngine  (ChangeNotifier)                │
│  ├─ ExpressionEvaluator   (skip logic / validation)     │
│  ├─ _answers / _repeatAnswers  (in-memory state)        │
│  ├─ exportAnswers() / loadAnswers()                     │
│  ├─ completionPercent / isSectionComplete()             │
│  └─ toggleLocale()   EN ↔ Tok Pisin                    │
└───────────────┬─────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────┐
│                      Data Layer                         │
│  IsarService (singleton)                                │
│  ├─ HouseholdRecord  @collection                        │
│  │   ├─ answersJson  (Map encoded as JSON string)        │
│  │   ├─ VectorClock  @embedded                          │
│  │   └─ status: draft │ complete │ synced │ conflict    │
│  └─ FormSchema  (assets/schemas/png_census_2025.json)   │
│      └─ Sections → Questions → Options / SkipConditions │
└───────────────┬─────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────┐
│                      Sync Layer                         │
│  SyncEngine  ── ConflictResolver (VectorClock)          │
│  TranslationService  (glossary → cache → Claude API)    │
│  BackgroundSync  (WorkManager, 15 min, network-gated)   │
└─────────────────────────────────────────────────────────┘"""

story.append(Preformatted(arch, mono))

# ── Schema ────────────────────────────────────────────────────────────────────
story.append(Paragraph("Census Form Schema", h2))
story.append(Paragraph(
    "The form is defined in a single JSON asset (<font name='Courier'>assets/schemas/png_census_2025.json</font>) "
    "and loaded at runtime. Adding new questions or sections requires only a JSON update — no code change.",
    body))

schema_data = [
    ["Section", "Questions", "Notable Features"],
    ["A — Location &amp;\nIdentification", "10",
     "Province selector (all 22 provinces), District, LLG, Ward,\nCensus Unit, Village, Household Number, HoH Name, GPS capture"],
    ["B — Household\nRoster", "1 repeat group\n(22 sub-questions\nper member)",
     "Name, Relationship, Sex, Age, DoB, Marital Status (age≥12),\nReligion, Language, Citizenship, Education, Literacy,\nEmployment, Occupation, Fertility — all with skip logic"],
    ["C — Dwelling\nCharacteristics", "10",
     "Type, Tenure, Sleeping Rooms, Floor/Wall/Roof materials,\nWater source, Toilet type, Cooking fuel, Lighting"],
]

schema_table = Table(schema_data, colWidths=[3.5*cm, 2.5*cm, 11*cm])
schema_table.setStyle(TableStyle([
    ("BACKGROUND",    (0,0), (-1,0),  INDIGO),
    ("TEXTCOLOR",     (0,0), (-1,0),  colors.white),
    ("FONTNAME",      (0,0), (-1,0),  "Helvetica-Bold"),
    ("FONTSIZE",      (0,0), (-1,0),  9),
    ("FONTSIZE",      (0,1), (-1,-1), 8.5),
    ("ROWBACKGROUNDS",(0,1), (-1,-1), [colors.white, LIGHT_INDIGO]),
    ("VALIGN",        (0,0), (-1,-1), "TOP"),
    ("GRID",          (0,0), (-1,-1), 0.4, colors.HexColor("#C5CAE9")),
    ("LEFTPADDING",   (0,0), (-1,-1), 6),
    ("RIGHTPADDING",  (0,0), (-1,-1), 6),
    ("TOPPADDING",    (0,0), (-1,-1), 5),
    ("BOTTOMPADDING", (0,0), (-1,-1), 5),
    ("FONTNAME",      (0,1), (0,-1),  "Helvetica-Bold"),
    ("TEXTCOLOR",     (0,1), (0,-1),  INDIGO),
]))
story.append(schema_table)

# ── Key design decisions ──────────────────────────────────────────────────────
story.append(Paragraph("Key Design Decisions", h2))

decisions = [
    ("Offline-first",
     "Isar embedded database stores all records locally. Sync is opportunistic — the app works fully without any network connection."),
    ("Vector Clocks",
     "Distributed conflict detection without a central authority. Each node (enumerator device, supervisor) increments its own counter. Causality comparison determines which record wins; concurrent edits are flagged for supervisor review."),
    ("JSON Answer Blob",
     "Answers are stored as a single JSON string in answersJson. This allows flexible schema evolution — adding or removing questions does not require a database migration."),
    ("Answer Pruning",
     "_pruneHidden() runs on every setAnswer() call and clears answers for questions that become hidden due to skip logic. This prevents stale data from reaching the submitted record."),
    ("3-Tier Translation",
     "The built-in glossary covers common census terminology instantly. The file-backed cache avoids repeat API calls. Claude Haiku with prompt-caching is the fallback — the large system prompt is cached server-side, keeping per-request cost low."),
    ("Platform Guards",
     "WorkManager (background sync) is Android/iOS only. All calls are wrapped in Platform.isAndroid || Platform.isIOS so the app also builds and runs on Linux desktop for development and testing."),
]

for title, detail in decisions:
    story.append(Paragraph(
        f"<b>{title}</b> — {detail}",
        ParagraphStyle("Decision", parent=body, leftIndent=10,
            borderLeftColor=INDIGO, borderLeftWidth=2, borderLeftPadding=6,
            spaceAfter=6)))

# ── Dependencies ──────────────────────────────────────────────────────────────
story.append(Paragraph("Dependencies", h2))

dep_data = [
    ["Package", "Version", "Purpose"],
    ["isar + isar_flutter_libs", "^3.1.0+1", "Embedded NoSQL database (offline storage)"],
    ["isar_generator + build_runner", "^3.1.0+1 / ^2.4", "Isar schema code generation"],
    ["provider", "^6.1.2", "ChangeNotifier state management"],
    ["connectivity_plus", "^6.1.4", "Network state detection"],
    ["geolocator", "^13.0.2", "GPS position with LocationSettings API"],
    ["image_picker", "^1.1.2", "Camera / gallery photo capture"],
    ["audioplayers", "^6.1.0", "Audio question prompt playback"],
    ["workmanager", "^0.9.0", "Background sync (Android/iOS)"],
    ["http", "^1.2.2", "HTTP client for sync and Claude API"],
    ["crypto", "^3.0.6", "SHA-256 cache key hashing for translations"],
    ["path_provider", "^2.1.5", "Application documents directory"],
    ["easy_localization", "^3.0.7", "i18n infrastructure"],
]

dep_table = Table(dep_data, colWidths=[5*cm, 2.5*cm, 9.5*cm])
dep_table.setStyle(TableStyle([
    ("BACKGROUND",    (0,0), (-1,0),  INDIGO),
    ("TEXTCOLOR",     (0,0), (-1,0),  colors.white),
    ("FONTNAME",      (0,0), (-1,0),  "Helvetica-Bold"),
    ("FONTSIZE",      (0,0), (-1,0),  9),
    ("FONTSIZE",      (0,1), (-1,-1), 8.5),
    ("ROWBACKGROUNDS",(0,1), (-1,-1), [colors.white, LIGHT_INDIGO]),
    ("VALIGN",        (0,0), (-1,-1), "TOP"),
    ("GRID",          (0,0), (-1,-1), 0.4, colors.HexColor("#C5CAE9")),
    ("LEFTPADDING",   (0,0), (-1,-1), 6),
    ("RIGHTPADDING",  (0,0), (-1,-1), 6),
    ("TOPPADDING",    (0,0), (-1,-1), 4),
    ("BOTTOMPADDING", (0,0), (-1,-1), 4),
    ("FONTNAME",      (0,1), (0,-1),  "Courier"),
    ("FONTSIZE",      (0,1), (0,-1),  8),
]))
story.append(dep_table)

# ── Footer ────────────────────────────────────────────────────────────────────
story.append(Spacer(1, 16))
story.append(HRFlowable(width="100%", thickness=0.5, color=colors.HexColor("#C5CAE9")))
story.append(Spacer(1, 4))
story.append(Paragraph(
    "PNG National Census 2025 · Flutter 3.41.9 · Dart 3.11.5 · Android 13 (API 33) tested",
    caption))

doc.build(story)
print(f"PDF written to: {OUTPUT}")
