package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestLibraryModulePyPI(t *testing.T) {
	defaults := common.GetTestDefaults()
	clusterID := defaults.ClusterID
	config := common.ModuleTestConfig{
		ModuleName:      "library",
		TestDescription: "Tests Databricks library module with PyPI package",
		RequiredVars: map[string]interface{}{
			"cluster_id": clusterID,
		},
		OptionalVars: map[string]interface{}{
			"pypi": map[string]interface{}{
				"package": "pandas",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"cluster_id",
		},
		SkipDestroy: true, // Requires existing cluster
	}

	common.TestModuleWithConfig(t, config)
}

func TestLibraryModuleMaven(t *testing.T) {
	defaults := common.GetTestDefaults()
	clusterID := defaults.ClusterID
	config := common.ModuleTestConfig{
		ModuleName:      "library",
		TestDescription: "Tests Databricks library module with Maven package",
		RequiredVars: map[string]interface{}{
			"cluster_id": clusterID,
		},
		OptionalVars: map[string]interface{}{
			"maven": map[string]interface{}{
				"coordinates": "org.apache.spark:spark-avro_2.12:3.3.0",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"cluster_id",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

func TestLibraryModuleJar(t *testing.T) {
	defaults := common.GetTestDefaults()
	clusterID := defaults.ClusterID
	config := common.ModuleTestConfig{
		ModuleName:      "library",
		TestDescription: "Tests Databricks library module with JAR file",
		RequiredVars: map[string]interface{}{
			"cluster_id": clusterID,
		},
		OptionalVars: map[string]interface{}{
			"jar": "dbfs:/FileStore/jars/test.jar",
		},
		ExpectedOutputs: []string{
			"id",
			"cluster_id",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

