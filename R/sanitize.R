sanitize_plan <- function(plan, allow_duplicated_targets = FALSE) {
  fields <- intersect(colnames(plan), c("command", "target", "trigger"))
  for (field in fields) {
    if (!is.null(plan[[field]])) {
      plan[[field]] <- factor_to_character(plan[[field]])
      if (is.character(plan[[field]])) {
        plan[[field]] <- trimws(plan[[field]])
      }
    }
  }
  plan$target <- repair_target_names(plan$target)
  plan <- plan[nzchar(plan$target), ]
  first <- c("target", "command")
  cols <- c(first, setdiff(colnames(plan), first))
  if (!allow_duplicated_targets) {
    plan <- handle_duplicated_targets(plan[, cols])
  }
  arrange_plan_cols(plan)
}

sanitize_targets <- function(plan, targets) {
  targets <- repair_target_names(targets)
  sanitize_nodes(nodes = targets, choices = plan$target)
}

sanitize_nodes <- function(nodes, choices) {
  if (!any(nodes %in% choices)) {
    stop(
      "All import/target names are invalid ",
      "in argument 'targets', 'from', or 'subset' ",
      "for make() or similar function.",
      call. = FALSE
    )
  }
  diffs <- setdiff(nodes, choices)
  if (length(diffs)) {
    warning(
      "Ignoring imports/targets that were requested but not found:\n",
      multiline_message(diffs),
      call. = FALSE
    )
  }
  unique(intersect(nodes, choices))
}

# TODO: get rid of the is_encoded_path() part in version 7.0.0
repair_target_names <- function(x) {
  index <- !is_quoted(x)
  x[index] <- make.names(x[index], unique = FALSE)
  x
}

sanitize_cmd_type <- function(x) {
  if (!is.language(x) && !is.expression(x) && !is.character(x)) {
    wide_deparse(x)
  } else {
    x
  }
}

arrange_plan_cols <- function(plan) {
  primary <- c("target", "command")
  others <- setdiff(colnames(plan), primary)
  plan[, c(primary, others)]
}
