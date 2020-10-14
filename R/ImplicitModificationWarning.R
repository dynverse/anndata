# #' @title ImplicitModificationWarning
# #'
# #' @description Raised whenever initializing an object or assigning a property changes
# #'
# #' @details the type of a part of a parameter or the value being assigned. Examples
# #' ========
# #' >>> import pandas as pd
# #' >>> adata = AnnData(obs=pd.DataFrame(index=[0, 1, 2])) # doctest: +SKIP
# #' ImplicitModificationWarning: Transforming to str index.
# #'
#
#
# #'
# #' @export
# ImplicitModificationWarning <- function() {
#   python_anndata$ImplicitModificationWarning()
# }
