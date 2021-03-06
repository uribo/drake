drake_context("deprecation")

test_with_dir("deprecation: fetch_cache", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  dp <- drake_plan(x = 1)
  expect_warning(make(dp, fetch_cache = ""), regexp = "deprecated")
  expect_warning(drake_config(dp, fetch_cache = ""), regexp = "deprecated")
  expect_warning(get_cache(fetch_cache = ""), regexp = "deprecated")
})

test_with_dir("pkgconfig::get_config(\"drake::strings_in_dots\")", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  old_strings_in_dots <- pkgconfig::get_config("drake::strings_in_dots")
  on.exit(
    pkgconfig::set_config("drake::strings_in_dots" = old_strings_in_dots)
  )
  cmd <- "readRDS('my_file.rds')"
  pkgconfig::set_config("drake::strings_in_dots" = "literals")
  expect_equal(command_dependencies(cmd), list(globals = "readRDS"))
  pkgconfig::set_config("drake::strings_in_dots" = "garbage")
  expect_equal(
    expect_warning(command_dependencies(cmd)),
    list(globals = "readRDS", file_in = "my_file.rds")
  )
})

test_with_dir("deprecation: examples", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  expect_warning(load_basic_example())
})

test_with_dir("deprecation: future", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  skip_if_not_installed("future")
  expect_warning(backend())
})

test_with_dir("deprecation: make() and config() etc.", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  expect_warning(default_system2_args(jobs = 1, verbose = FALSE))
  expect_warning(make(drake_plan(x = 1), return_config = TRUE,
    verbose = FALSE, session_info = FALSE))
  config <- expect_warning(config(drake_plan(x = 1)))
  expect_warning(deps_targets("x", config), regexp = "deprecated")
})

test_with_dir("deprecation: cache functions", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  plan <- drake_plan(x = 1)
  expect_error(expect_warning(tmp <- read_drake_meta(search = FALSE)))
  expect_silent(make(plan, verbose = FALSE, session_info = FALSE))
  expect_true(is.numeric(readd(x, search = FALSE)))
  expect_equal(cached(), "x")
  expect_warning(read_config())
  expect_warning(read_graph())
  expect_warning(read_plan())
  expect_true(expect_warning(is.list(
    tmp <- read_drake_meta(targets = NULL, search = FALSE))))
  expect_true(expect_warning(is.list(
    tmp <- read_drake_meta(targets = "x", search = FALSE))))
  cache <- get_cache()
  expect_warning(short_hash(cache))
  expect_warning(long_hash(cache))
  expect_warning(default_short_hash_algo(cache))
  expect_warning(default_long_hash_algo(cache))
  expect_warning(available_hash_algos())
  expect_warning(new_cache(short_hash_algo = "123", long_hash_algo = "456"))
})

test_with_dir("drake_plan deprecation", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  pl1 <- expect_warning(drake::plan(x = 1, y = x))
  pl2 <- drake_plan(x = 1, y = x)
  pl3 <- expect_warning(plan_drake(x = 1, y = x))
  expect_warning(drake::plan())
  expect_warning(drake::plan_drake())
  expect_warning(drake::workflow())
  expect_warning(drake::workplan())
  expect_warning(drake::plan(x = y, file_targets = TRUE))
  expect_warning(drake::plan_drake(x = y, file_targets = TRUE))
  expect_warning(drake::workflow(x = y, file_targets = TRUE))
  expect_warning(drake::workplan(x = y, file_targets = TRUE))
  expect_warning(check(drake_plan(a = 1)))
  expect_warning(drake_plan(a = 'file', strings_in_dots = NULL)) # nolint
})

test_with_dir("drake version checks in previous caches", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  # We need to be able to set the drake version
  # to check back compatibility.
  plan <- drake_plan(x = 1)
  expect_silent(make(plan, verbose = FALSE))
  x <- get_cache()
  expect_warning(session())
  suppressWarnings(expect_error(drake_session(cache = NULL), regexp = "make"))
  expect_warning(drake_session(cache = x), regexp = "deprecated")
})

test_with_dir("generative templating deprecation", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  expect_warning(drake::evaluate(drake_plan()))
  expect_warning(drake::expand(drake_plan()))
  expect_warning(drake::gather(drake_plan()))
  datasets <- drake_plan(
    small = simulate(5),
    large = simulate(50))
  methods <- drake_plan(
    regression1 = reg1(..dataset..), # nolint
    regression2 = reg2(..dataset..)) # nolint
  expect_warning(
    analyses <- analyses(methods, datasets = datasets))
  summary_types <- drake_plan(
    summ = summary(..analysis..), # nolint
    coef = stats::coefficients(..analysis..)) # nolint
  expect_warning(
    summaries(summary_types, analyses, datasets))
})

test_with_dir("deprecated graphing functions", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  pl <- drake_plan(a = 1, b = 2)
  expect_warning(build_graph(pl))
  expect_warning(build_drake_graph(pl))
  con <- drake_config(plan = pl)
  skip_if_not_installed("lubridate")
  skip_if_not_installed("visNetwork")
  expect_warning(out <- plot_graph(config = con))
  expect_warning(out <- plot_graph(plan = pl))
  skip_if_not_installed("ggraph")
  expect_warning(out <- static_drake_graph(config = con))
  expect_true(inherits(out, "gg"))
  df <- drake_graph_info(config = con)
  expect_warning(out <- render_graph(df))
  expect_warning(out <- render_static_drake_graph(df))
  expect_true(inherits(out, "gg"))
})

test_with_dir("deprecated example(s)_drake functions", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  skip_if_not_installed("downloader")
  expect_warning(example_drake())
  expect_warning(examples_drake())
})

test_with_dir("deprecate misc utilities", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  skip_if_not_installed("lubridate")
  skip_if_not_installed("visNetwork")
  expect_error(parallel_stages(1), regexp = "parallelism")
  expect_error(rate_limiting_times(1), regexp = "parallelism")
  expect_warning(as_file("x"))
  expect_warning(as_drake_filename("x"))
  expect_warning(drake_unquote("x", deep = TRUE))
  cache <- storr::storr_environment()
  expect_warning(configure_cache(
    cache, log_progress = TRUE, init_common_values = TRUE
  ))
  expect_warning(max_useful_jobs(config(drake_plan(x = 1))))
  expect_warning(deps(123))
  load_mtcars_example()
  expect_warning(config <- drake_config(my_plan, graph = 1, layout = 2))
  expect_warning(tmp <- dataframes_graph(config))
  expect_warning(migrate_drake_project())
  expect_null(warn_single_quoted_files(character(0), list()))
})

test_with_dir("deprecated arguments", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  pl <- drake_plan(a = 1, b = a)
  expect_warning(
    con <- drake_config(
      plan = pl,
      session_info = FALSE,
      imports_only = FALSE
    )
  )
  expect_warning(drake_build(a, config = con, meta = list()))
})

test_with_dir("old file API", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  skip_if_not_installed("datasets")
  old_strings_in_dots <- pkgconfig::get_config("drake::strings_in_dots")
  on.exit(
    pkgconfig::set_config("drake::strings_in_dots" = old_strings_in_dots)
  )
  pkgconfig::set_config("drake::strings_in_dots" = "filenames")
  expect_warning(x <- drake_plan(
    file.csv = write.csv(datasets::mtcars, file = "file.csv"),
    strings_in_dots = "literals",
    file_targets = TRUE
  ))
  expect_warning(y <- drake_plan(
    contents = read.csv('file.csv'), # nolint
    strings_in_dots = "filenames"
  ))
  z <- rbind(x, y)
  expect_warning(config <- drake_config(z))
  expect_warning(make(z, session_info = FALSE) -> config)
  expect_equal(readd("'file.csv'"), readd("\"file.csv\""))
})

test_with_dir("example template files (deprecated)", {
  skip_on_cran()
  expect_false(file.exists("slurm_batchtools.tmpl"))
  expect_warning(
    drake_batchtools_tmpl_file("slurm_batchtools.tmpl"),
    regexp = "deprecated"
  )
  expect_true(file.exists("slurm_batchtools.tmpl"))
})

test_with_dir("plan set 1", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  old_strings_in_dots <- pkgconfig::get_config("drake::strings_in_dots")
  on.exit(
    pkgconfig::set_config("drake::strings_in_dots" = old_strings_in_dots)
  )
  pkgconfig::set_config("drake::strings_in_dots" = "filenames")
  for (tidy_evaluation in c(TRUE, FALSE)) {
    expect_warning(x <- drake_plan(
      a = c,
      b = "c",
      list = c(c = "d", d = "readRDS('e')"),
      tidy_evaluation = tidy_evaluation,
      strings_in_dots = "filenames"
    ))
    y <- weak_tibble(
      target = letters[1:4],
      command = c("c", "'c'",
      "d", "readRDS('e')"))
    expect_equal(x, y)
    expect_warning(con <- drake_config(x))
    expect_warning(runtime_checks(con))
  }
})

test_with_dir("force with a non-back-compatible cache", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  expect_equal(cache_vers_check(NULL), character(0))
  expect_null(get_cache())
  expect_null(this_cache())
  expect_true(inherits(recover_cache(), "storr"))
  write_v4.3.0_project() # nolint
  expect_warning(get_cache(), regexp = "compatible")
  expect_warning(this_cache(), regexp = "compatible")
  expect_warning(recover_cache(), regexp = "compatible")
  suppressWarnings(
    expect_error(drake_config(drake_plan(x = 1)), regexp = "compatible")
  )
  suppressWarnings(
    expect_error(make(drake_plan(x = 1)), regexp = "compatible")
  )
  expect_warning(make(drake_plan(x = 1), force = TRUE), regexp = "compatible")
  expect_silent(tmp <- get_cache())
  expect_silent(tmp <- this_cache())
  expect_silent(tmp <- recover_cache())
})

test_with_dir("v6.2.1 project is still up to date", {
  skip_on_cran() # CRAN gets whitelist tests only (check time limits).
  skip_if_not_installed("datasets")
  skip_if_not_installed("tibble")
  skip_if_not_installed("knitr")
  requireNamespace("datasets")
  write_v6.2.1_project() # nolint
  report_md_hash <- readRDS(
    file.path(".drake", "data", "983396f9689f587b.rds")
  )
  expect_equal(nchar(report_md_hash), 64L)
  plan <- read_drake_plan()
  random_rows <- function(data, n) {
    data[sample.int(n = nrow(data), size = n, replace = TRUE), ]
  }
  simulate <- function(n) {
    data <- random_rows(data = mtcars, n = n)
    data.frame(
      x = data$wt,
      y = data$mpg
    )
  }
  reg1 <- function(d) {
    lm(y ~ + x, data = d)
  }
  reg2 <- function(d) {
    d$x2 <- d$x ^ 2
    lm(y ~ x2, data = d)
  }
  require("knitr", quietly = TRUE) # nolint
  config <- drake_config(plan)
  expect_equal(outdated(config), character(0))
  config <- make(plan)
  expect_equal(justbuilt(config), character(0))

  # Does it still respond correctly to changes in output files?
  lines <- c(readLines("report.md"), "", "Last line.")
  writeLines(lines, "report.md")
  expect_equal(outdated(config), "report")
  config <- make(config = config)
  expect_equal(justbuilt(config), "report")
  expect_equal(outdated(config), character(0))

  # How about knitr files?
  lines <- c(readLines("report.Rmd"), "", "Last line.")
  writeLines(lines, "report.Rmd")
  expect_equal(outdated(config), "report")
  requireNamespace("knitr")
  config <- make(config = config)
  expect_equal(justbuilt(config), "report")
  expect_equal(outdated(config), character(0))
})

test_with_dir("deprecate the `force` argument", {
  expect_warning(tmp <- get_cache(force = TRUE), regexp = "deprecated")
  expect_warning(tmp <- this_cache(force = TRUE), regexp = "deprecated")
  expect_warning(tmp <- recover_cache(force = TRUE), regexp = "deprecated")
  expect_warning(load_mtcars_example(force = TRUE), regexp = "deprecated")
})

test_with_dir("timeout argument", {
  expect_warning(
    make(
      drake_plan(x = 1),
      timeout = 5,
      session_info = FALSE,
      cache = storr::storr_environment()
    )
  )
})

test_with_dir("old trigger interface", {
  skip_on_cran()
  for (old_trigger in suppressWarnings(triggers())) {
    plan <- drake_plan(x = 1)
    plan$trigger <- old_trigger
    clean()
    expect_warning(
      config <- make(
        plan,
        session_info = FALSE,
        cache = storr::storr_environment()
      ),
      regexp = "old trigger interface is deprecated"
    )
    trigger <- diagnose(x, cache = config$cache)$trigger
    expect_true(is.list(trigger))
    if (identical(trigger$condition, TRUE)) {
      expect_equal(old_trigger, "always")
    } else {
      expect_false(old_trigger == "always")
    }
    expect_equal(
      trigger$command,
      old_trigger %in% c("always", "any", "command")
    )
    expect_equal(
      trigger$file,
      old_trigger %in% c("always", "any", "file")
    )
    expect_equal(
      trigger$depend,
      old_trigger %in% c("always", "any", "depends")
    )
  }
})

test_with_dir("mtcars example", {
  skip_on_cran()
  expect_warning(
    load_mtcars_example(report_file = "other_name.Rmd"),
    regexp = "report_file"
  )
})

test_with_dir("deprecated hooks", {
  expect_warning(
    make(
      drake_plan(x = 1),
      hook = 123,
      session_info = FALSE,
      cache = storr::storr_environment()
    ),
    regexp = "deprecated"
  )
  expect_warning(default_hook(NULL), regexp = "deprecated")
  expect_warning(empty_hook(NULL), regexp = "deprecated")
  expect_warning(message_sink_hook(NULL), regexp = "deprecated")
  expect_warning(output_sink_hook(NULL), regexp = "deprecated")
  expect_warning(silencer_hook(NULL), regexp = "deprecated")
})

test_with_dir("pruning_strategy", {
  expect_warning(
    make(
      drake_plan(x = 1),
      pruning_strategy = 123,
      session_info = FALSE,
      cache = storr::storr_environment()
    ),
    regexp = "deprecated"
  )
})

test_with_dir("main example", {
  skip_on_cran()
  skip_if_not_installed("downloader")
  skip_if_not_installed("ggplot2")
  for (file in c("raw_data.xlsx", "report.Rmd")) {
    expect_false(file.exists(file))
  }

  # load_main_example() is now deprecated so should get a warning
  expect_warning(load_main_example())

  for (file in c("raw_data.xlsx", "report.Rmd")) {
    expect_true(file.exists(file))
  }
  expect_warning(load_main_example(overwrite = TRUE), regexp = "Overwriting")
  expect_warning(clean_main_example())
  for (file in c("raw_data.xlsx", "report.Rmd")) {
    expect_false(file.exists(file))
  }
})

test_with_dir("session arg to make()", {
  expect_warning(
    make(drake_plan(x = 1), session = "callr::r_vanilla"),
    regexp = "lock_envir"
  )
})
