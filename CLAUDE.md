# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Visual FoxPro (VFP) desktop application for carpet manufacturing / export inventory for **Kamal Rug Industries Pvt. Ltd.** (Lalitpur, Nepal). It tracks buyers and buyer orders, designs/qualities, weavers and loom progress, wool/yarn purchase, dyeing, washing, stock, packing lists and export invoices. The directory is flat: about 2,500 files, all in the root. It is not a git repository.

## Building and running

There is no CLI build, lint or test tooling. Everything runs inside the Visual FoxPro IDE (VFP 6/9 era; wizard files are under `program files/microsoft visual studio/vfp98`).

- **Main project:** `carpet.PJX`/`carpet.PJT`. The other `*.PJX` files are 1.3 KB empty stubs.
- **Build:** in the VFP command window, `BUILD APP carpet FROM carpet` (or use the Project Manager's Build button). The output is `carpet.app`.
- **Run:** `DO carpet.app`, or run the entry program directly with `DO main`.
- **Run one report or program on its own:** `OPEN DATABASE carpet`, set the `m.` variables the program expects (see "Report programs" below), then `DO <prgname>`.
- `.FXP` files are compiled `.PRG` files. VFP regenerates them, so never edit them by hand.

## Architecture

**Entry point: `main.PRG`.** It sets the environment (`SET DELETED ON`, `SET DATE BRITISH`, and so on) and installs the global error handler `errhand IN errutil`. It runs `SET PROCEDURE TO CATOOL`, declares the company-info publics (`pcname`, `padd0..2`) and `pstartdt`, and defines the shared report preview window `wReport`. It then runs `DO FORM pass` (the login, backed by `PASSWORD.DBF`) followed by `READ EVENTS`.

After login, the public `plevel` picks the menu: `LEVEL1`→`Carpet.mpr`, `LEVEL2`→`Carpet1.mpr`, `LEVEL3`→`Carpet2.mpr`, `LEVEL4`→`Carpet3.mpr`, `LEVEL5`→`Carpet4.mpr` (supervisor), `GRAPH`→`Graph.mpr`, `YARN1/YARN2`→`dyedyrn(1).mpr`, `WYARN`→`wyarn.mpr`. Access control works through menus only: to expose a feature to a role, add it to that role's menu.

- **Menus:** the `.MNX`/`.MNT` files are the source. The `.MPR` files are generated from them by the VFP menu generator, so edit the `.MNX` and regenerate rather than hand-editing the `.MPR`.
- **Legacy files:** `main1.prg` (a different company, Himalayan Carpet) and `carpet.prg` (an old FoxPro-for-DOS style main that uses `CATools`) are older entry points. They are not the active startup.
- **Shared library:** `catool.PRG` holds the shared procedures and functions (`YesNo`, `FileLock`, `PwCoding`, `ccsMatch*` crosstab helpers, and others). Because it is loaded with `SET PROCEDURE`, it is callable from anywhere.
- **Data:** the database container is `carpet.dbc`. Its tables are the `.DBF` files, with `.CDX` indexes and `.FPT` memo files. Many index files also live in `program files/`. Table prefixes show the domain: `Ca*` is core carpet (buyer, design, quality, colour, weaver, loom size, buyer orders), `Wi*`/`wool*` is wool, `Yrn*`/`Yr*` is yarn, `Gr*` is goods received, `Pack*`/`expacking*` is packing and export, and `Wash*` is washing.
- **Forms:** the `.SCX`/`.SCT` files (about 280). They are binary VFP tables, so edit them in the Form Designer. Text tools can only grep them (`strings`). Many forms collect parameters into `m.` memory variables, then `DO` a report program.
- **Report programs:** most `.PRG` files are report programs (prefixes `r*`, `rep*`, `rp*`, `ro*`, `tt*`, `in*`). They share one pattern:
  1. `SELECT ... INTO CURSOR` (often with joins against `Caqlty`, `Cadesign`, and so on).
  2. Show "Record Not Found" if the cursor is empty.
  3. A `DO CASE` on `m.PrnStat` (`"V"` means preview with `REPORT FORM x.frx PREVIEW WINDOW wReport`; `"P"` means `TO PRINTER PROMPT NOCONSOLE`), plus option flags such as `m.Option` and `m.chk1`.

  The reports themselves are the `.FRX`/`.FRT` files.
- **Class libraries:** the `WIZ*.VCX` files are stock VFP wizard style libraries.

## Conventions and gotchas

- **Backup copies:** there are many ad-hoc copies such as `*-old.prg`, `*-ok.prg`, `*2.prg` and `*smy.prg` (summary variant). Before editing, find which file the form or menu actually calls. Grep the `.SCT`, `.MNX` and `.MPR` files for the program name.
- **Error codes:** `errutil.prg` silently tolerates error 3/110 (file in use) and 1705 (access denied). Every other error opens a full-screen error window.
- **Multi-user:** the app is multi-user over shared DBFs (`SET REPROCESS TO 5 SECONDS`), so avoid code that needs `EXCLUSIVE` use at runtime.
- **Dates:** dates are British (dd/mm/yyyy) and use strict date literals such as `{^2025/01/01}`. Deleted records are hidden globally (`SET DELETED ON`).
- **Bulk yarn issue (`wibulk.prg`, table `Wiissue_bulk`):** one bulk line (total kg) per issue to one Order Form, keyed by `Casupord.GRPID` (N 6, set by "GrpID Update" on `rordform.scx`; listed by the `orderformview` view on `mastordform.scx`). Commit divides the kg by `Cabuyord.Sqmt` over every OL with that GRPID into normal `Wiissue` rows (OL, card, weaver, PO per OL). Each bulk line has its own `BULKID`, and its Wiissue rows carry it in `Wiissue.GRPID` (C 15), so one GRPID can have many bulk lines. `wibulk.prg` is a self-contained form class (`frmWiBulk`, plus a `frmWbPick` GRPID picker) run with `do wibulk`; `lSilent` / `lCheckStock` switch off dialogs and the stock check for scripts. Tables are prepared once with `DO wiissue_addgrp` then `DO wiissue_bulk_create` (both need exclusive access; the second drops an EMPTY old-structure Wiissue_bulk). The old OL-based version is `wibulk-ol.prg`. Edit/Delete are blocked once any row has a printed `SlipNo`. Headless tests: the live DBC is usually locked, so test on free-table copies in a fresh DBC (`CREATE DATABASE` + `ADD TABLE`), with `SET EXCLUSIVE OFF`.
- **Editing SCX/VCX without the designer:** forms run from compiled OBJCODE, so after changing a `METHODS` memo (`USE x.scx` then `REPLACE methods ...`) run `COMPILE FORM x.scx`. This works headless with `"C:\Program Files (x86)\Microsoft Visual Studio\Vfp98\VFP6.EXE" -T script.prg`, and a test script can drive a form (`DO FORM x NAME oF`, then `SET DATASESSION TO oF.DataSessionId`, then call the button `Click()` methods). Test on a copy of the data, not this folder. In this snapshot the `.CDX` files of `Casupord`/`Cabuyord` are stale and SQL returns wrong rows until the copy is reindexed.
