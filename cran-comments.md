# anndata 0.7.5.4

* BUG FIX: Set dimnames on layer views as well (#16).

* BUG FIX: Fix Github Actions for R CMD Check, test-coverage and pkgdown.

* DOCUMENTATION: Fix pkgdown config structure by adding missing topics.

* DOCUMENTATION: Regenerate the Rd files using the current CRAN version of roxygen2.

--------------------------------------------------------------------------

## Test environments
* local R installation, R 4.0.3
* win-builder (devel)
* Github Actions: 
  - Windows, R release
  - Mac OS X, R release
  - Ubuntu, R devel
  - Ubuntu, R release
  - Ubuntu, R oldrelease

── R CMD check results ──────────────────────────────────── anndata 0.7.5.4 ────
Duration: 37.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

R CMD check succeeded

## Revdepcheck
revdepcheck resulted in no new errors or warnings for reverse dependencies.

```
> revdepcheck::revdep_check(timeout = as.difftime(600, units = "mins"), num_workers = 30)
── CHECK ───────────────────────────────────────────────────────── 1 packages ──
I dyngen 1.0.3                           ── E: 1     | W: 0     | N: 1                                                                                 
OK: 1                                                                                                                                                
BROKEN: 0
Total time: 15 min
── REPORT ──────────────────────────────────────────────────────────────────────
Writing summary to 'revdep/README.md'
Writing problems to 'revdep/problems.md'
Writing failures to 'revdep/failures.md'
Writing CRAN report to 'revdep/cran.md'
```
