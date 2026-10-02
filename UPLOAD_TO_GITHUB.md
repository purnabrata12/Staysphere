# Add this README pack to your StaySphere GitHub repository

The ZIP is a **GitHub README asset package**, not a replacement for the application code.

1. Extract `StaySphere_Complete_GitHub_README.zip`.
2. Copy its **README.md** into the root of your existing StaySphere repository; this replaces the old README.
3. Copy the **entire `docs/` folder** alongside README.md. It includes the brand banner and 14 renamed screenshots.
4. Keep your `frontend/`, `backend/` and `database/` application folders unchanged.
5. Commit both the README and docs assets together.

Example terminal commands (from your repository root):

```powershell
git add README.md docs/
git commit -m "docs: refresh StaySphere README and screenshot gallery"
git push
```

IMPORTANT: Do not upload your `backend/.env`, tokens or live credentials. If you later rename screenshots, update the references inside README.md too.
