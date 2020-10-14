#' @title get_version
#'
#' @description If supplied, relative_to should be a file from which root may
#'
#' @details be resolved. Typically called by a script or module that is not
#' in the root of the repository to direct setuptools_scm to the
#' root of the repository by supplying ``__file__``.
#'
#' @param root root
#' @param version_scheme version_scheme
#' @param local_scheme local_scheme
#' @param write_to write_to
#' @param write_to_template write_to_template
#' @param relative_to relative_to
#' @param tag_regex tag_regex
#' @param parentdir_prefix_version parentdir_prefix_version
#' @param fallback_version fallback_version
#' @param fallback_root fallback_root
#' @param parse parse
#' @param git_describe_command git_describe_command
#'
#' @export
get_version <- function(root = ".", version_scheme = "guess-next-dev", local_scheme = "node-and-date", write_to = NULL, write_to_template = NULL, relative_to = NULL, tag_regex = "^(?:[\\w-]+-)?(?P<version>[vV]?\\d+(?:\\.\\d+){0,2}[^\\+]*)(?:\\+.*)?$", parentdir_prefix_version = NULL, fallback_version = NULL, fallback_root = ".", parse = NULL, git_describe_command = NULL) {
  python_function_result <- python_anndata$get_version(
    root = root,
    version_scheme = version_scheme,
    local_scheme = local_scheme,
    write_to = write_to,
    write_to_template = write_to_template,
    relative_to = relative_to,
    tag_regex = tag_regex,
    parentdir_prefix_version = parentdir_prefix_version,
    fallback_version = fallback_version,
    fallback_root = fallback_root,
    parse = parse,
    git_describe_command = git_describe_command
  )
}
