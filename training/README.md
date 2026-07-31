# TernaryCore training track

Plan: `docs/DISTILLATION_PLAN.md` · Beginner guide: `docs/DISTILLATION_GUIDE.md`

- **D0** (this folder): environment + floor/ceiling measurements. Run
  `bash d0_run.sh` (waits for the venv install, then does everything;
  log in `~/tc-d0.log` if launched with nohup).
- Results land in `D0-results.md` + `requirements-frozen.txt` — review,
  then commit to `feat/distillation`.
- No training happens in D0. First training code arrives with D2 (SubLN
  surgery) after the D1 teacher/task decision is committed.
