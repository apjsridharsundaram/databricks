resource "databricks_library" "this" {
  cluster_id = var.cluster_id

  jar  = var.jar
  egg  = var.egg
  whl  = var.whl

  dynamic "pypi" {
    for_each = var.pypi != null ? [var.pypi] : []
    content {
      package = pypi.value.package
      repo    = pypi.value.repo
    }
  }

  dynamic "maven" {
    for_each = var.maven != null ? [var.maven] : []
    content {
      coordinates = maven.value.coordinates
      repo        = maven.value.repo
      exclusions  = maven.value.exclusions
    }
  }

  dynamic "cran" {
    for_each = var.cran != null ? [var.cran] : []
    content {
      package = cran.value.package
      repo    = cran.value.repo
    }
  }
}




