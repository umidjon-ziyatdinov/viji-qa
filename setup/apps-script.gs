/**
 * Viji QA — shared webhook (bound Apps Script). Two tabs:
 *
 *   "Findings"  — bugs only (team edits Status/Owner/Notes directly).
 *   "Test log"  — one row per case RUN, so planning avoids repeats and the team
 *                 sees collective coverage. Case numbers are global and live here.
 *
 * Paste this into the QA sheet's Apps Script editor (Extensions > Apps Script FROM the
 * sheet, so it is BOUND to it), then deploy as a Web App. See WEBHOOK-SETUP.md.
 *
 *   doGet()  -> { findings:[...], testlog:[...], next_case_no: N }
 *               findings  -> dedup bugs before inserting.
 *               testlog   -> the cases already run (for uniqueness) + max case_no.
 *   doPost() -> body may carry {"rows":[...]} (append Findings) and/or
 *               {"cases":[...]} (append Test log). Either or both. Append only.
 */

var FINDINGS = "Findings";
var TESTLOG = "Test log";

var FINDINGS_HEADER = ["Found date","Severity","Area","Title","Scenario","Expected","Actual",
                       "Evidence","Conversation","Status","Owner","Found by","Notes"];
var TESTLOG_HEADER = ["Case #","Title","Service","Language","Behaviour","Outcome",
                      "Conversation","Tester","Date","Notes"];

function tab_(name, header) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sh = ss.getSheetByName(name);
  if (!sh) {
    sh = ss.insertSheet(name);
    sh.appendRow(header);
    sh.setFrozenRows(1);
    sh.getRange(1, 1, 1, header.length).setFontWeight("bold");
  }
  return sh;
}

function indexOf_(sh) {
  var values = sh.getDataRange().getValues();
  var header = values.shift() || [];
  var idx = {};
  header.forEach(function (h, i) { idx[h] = i; });
  return { rows: values, idx: idx };
}

function doGet() {
  var f = indexOf_(tab_(FINDINGS, FINDINGS_HEADER));
  var findings = f.rows
    .filter(function (r) { return r[f.idx["Title"]]; })
    .map(function (r) {
      return {
        title: r[f.idx["Title"]],
        area: r[f.idx["Area"]],
        severity: r[f.idx["Severity"]],
        conversation: r[f.idx["Conversation"]],
        status: r[f.idx["Status"]]
      };
    });

  var t = indexOf_(tab_(TESTLOG, TESTLOG_HEADER));
  var maxNo = 0;
  var testlog = t.rows
    .filter(function (r) { return r[t.idx["Case #"]] || r[t.idx["Title"]]; })
    .map(function (r) {
      var no = parseInt(r[t.idx["Case #"]], 10);
      if (!isNaN(no) && no > maxNo) maxNo = no;
      return {
        case_no: r[t.idx["Case #"]],
        title: r[t.idx["Title"]],
        service: r[t.idx["Service"]],
        language: r[t.idx["Language"]],
        behaviour: r[t.idx["Behaviour"]],
        outcome: r[t.idx["Outcome"]],
        conversation: r[t.idx["Conversation"]],
        tester: r[t.idx["Tester"]]
      };
    });

  return ContentService
    .createTextOutput(JSON.stringify({ findings: findings, testlog: testlog, next_case_no: maxNo + 1 }))
    .setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  var body = {};
  try { body = JSON.parse(e.postData.contents) || {}; } catch (err) { body = {}; }
  var today = Utilities.formatDate(new Date(), Session.getScriptTimeZone(), "yyyy-MM-dd");

  var rows = body.rows || [];
  if (rows.length) {
    var fsh = tab_(FINDINGS, FINDINGS_HEADER);
    rows.forEach(function (r) {
      fsh.appendRow([
        r.found_at || today, r.severity || "", r.area || "", r.title || "",
        r.scenario || "", r.expected || "", r.actual || "", r.evidence || "",
        r.conversation_id || r.conversation || "", r.status || "New",
        r.owner || "", r.found_by || "QA agent", r.notes || ""
      ]);
    });
  }

  var cases = body.cases || [];
  if (cases.length) {
    var tsh = tab_(TESTLOG, TESTLOG_HEADER);
    cases.forEach(function (c) {
      tsh.appendRow([
        c.case_no || "", c.title || "", c.service || "", c.language || "",
        c.behaviour || "", c.outcome || "", c.conversation_id || c.conversation || "",
        c.tester || "QA agent", c.date || today, c.notes || ""
      ]);
    });
  }

  return ContentService
    .createTextOutput(JSON.stringify({ ok: true, findings_added: rows.length, cases_added: cases.length }))
    .setMimeType(ContentService.MimeType.JSON);
}
