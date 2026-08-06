/**
 * Viji QA — shared findings webhook (bound Apps Script).
 *
 * Paste this into the QA sheet's Apps Script editor (Extensions > Apps Script FROM the
 * sheet, so it is BOUND to it), then deploy as a Web App. See WEBHOOK-SETUP.md.
 *
 *   doGet()  -> returns existing findings, so the agent can dedup before inserting.
 *   doPost() -> appends new finding rows to the "Findings" tab.
 *
 * The "Findings" tab includes team collaboration columns (Status, Owner, Found by, Notes)
 * that people edit directly in the sheet. The agent only ever appends; it never overwrites.
 */

var HEADER = ["Found date","Severity","Area","Title","Scenario","Expected","Actual",
              "Evidence","Conversation","Status","Owner","Found by","Notes"];

function sheet_() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sh = ss.getSheetByName("Findings");
  if (!sh) {
    sh = ss.insertSheet("Findings");
    sh.appendRow(HEADER);
    sh.setFrozenRows(1);
    sh.getRange(1, 1, 1, HEADER.length).setFontWeight("bold");
  }
  return sh;
}

function doGet() {
  var sh = sheet_();
  var values = sh.getDataRange().getValues();
  var header = values.shift() || [];
  var idx = {};
  header.forEach(function (h, i) { idx[h] = i; });
  var findings = values
    .filter(function (r) { return r[idx["Title"]]; })
    .map(function (r) {
      return {
        title: r[idx["Title"]],
        area: r[idx["Area"]],
        severity: r[idx["Severity"]],
        conversation: r[idx["Conversation"]],
        status: r[idx["Status"]]
      };
    });
  return ContentService
    .createTextOutput(JSON.stringify({ findings: findings }))
    .setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  var sh = sheet_();
  var rows = [];
  try { rows = (JSON.parse(e.postData.contents).rows) || []; } catch (err) { rows = []; }
  var today = Utilities.formatDate(new Date(), Session.getScriptTimeZone(), "yyyy-MM-dd");
  rows.forEach(function (r) {
    sh.appendRow([
      r.found_at || today,
      r.severity || "",
      r.area || "",
      r.title || "",
      r.scenario || "",
      r.expected || "",
      r.actual || "",
      r.evidence || "",
      r.conversation_id || r.conversation || "",
      r.status || "New",
      r.owner || "",
      r.found_by || "QA agent",
      r.notes || ""
    ]);
  });
  return ContentService
    .createTextOutput(JSON.stringify({ ok: true, added: rows.length }))
    .setMimeType(ContentService.MimeType.JSON);
}
