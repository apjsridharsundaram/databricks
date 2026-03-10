package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestClusterModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	instanceProfile := defaults.InstanceProfile

	uniqueID := common.GenerateUniqueTestID("cluster")

	config := common.ModuleTestConfig{
		ModuleName:      "cluster",
		TestDescription: "Tests Databricks cluster module",
		RequiredVars: map[string]interface{}{
			"cluster_name":  uniqueID,
			"spark_version": defaults.SparkVersion,
			"node_type_id":  defaults.NodeTypeID,
		},
		OptionalVars: map[string]interface{}{
			"num_workers":                  10, // Scalable for production workloads
			"autotermination_minutes":      10,
			"enable_elastic_disk":          true,
			"enable_local_disk_encryption": true,
			"data_security_mode":           "USER_ISOLATION",
			"policy_id":                    "00086E12C5E587D2", // Use deployed cluster policy
			"aws_attributes": map[string]interface{}{
				"instance_profile_arn": instanceProfile,
				"availability":         "SPOT_WITH_FALLBACK",
			},
			"spark_conf": map[string]string{
				"spark.databricks.delta.preview.enabled": "true",
			},
			"custom_tags": map[string]string{
				"Environment": "test",
				"CreatedBy":   "terratest",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"cluster_id",
			"cluster_name",
			"state",
			"default_tags",
			"url",
		},
		SkipDestroy: false,
	}

	common.TestModuleWithConfig(t, config)
}

func TestClusterModuleWithAutoscale(t *testing.T) {
	defaults := common.GetTestDefaults()
	instanceProfile := defaults.InstanceProfile

	uniqueID := common.GenerateUniqueTestID("cluster-auto")

	config := common.ModuleTestConfig{
		ModuleName:      "cluster",
		TestDescription: "Tests Databricks cluster module with autoscaling",
		RequiredVars: map[string]interface{}{
			"cluster_name":  uniqueID,
			"spark_version": defaults.SparkVersion,
			"node_type_id":  defaults.NodeTypeID,
		},
		OptionalVars: map[string]interface{}{
			"autoscale": map[string]interface{}{
				"min_workers": 1,
				"max_workers": 3,
			},
			"autotermination_minutes":      10,
			"data_security_mode":           "USER_ISOLATION",
			"enable_local_disk_encryption": true,
			"policy_id":                    "00086E12C5E587D2", // Use deployed cluster policy
			"aws_attributes": map[string]interface{}{
				"instance_profile_arn": instanceProfile,
			},
		},
		ExpectedOutputs: []string{
			"id",
			"cluster_id",
			"cluster_name",
			"state",
			"default_tags",
			"url",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestClusterModuleWithInstancePool(t *testing.T) {
	defaults := common.GetTestDefaults()
	instanceProfile := defaults.InstanceProfile

	uniqueID := common.GenerateUniqueTestID("cluster-pool")

	config := common.ModuleTestConfig{
		ModuleName:      "cluster",
		TestDescription: "Tests Databricks cluster module with instance pool",
		RequiredVars: map[string]interface{}{
			"cluster_name":  uniqueID,
			"spark_version": defaults.SparkVersion,
			"node_type_id":  defaults.NodeTypeID,
		},
		OptionalVars: map[string]interface{}{
			"num_workers":             20, // Scalable for distributed processing
			"autotermination_minutes": 10,
			"data_security_mode":      "USER_ISOLATION",
			"policy_id":               "00086E12C5E587D2", // Use deployed cluster policy
			"aws_attributes": map[string]interface{}{
				"instance_profile_arn": instanceProfile,
				"availability":         "SPOT_WITH_FALLBACK",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"cluster_id",
			"cluster_name",
			"state",
			"default_tags",
			"url",
		},
	}

	common.TestModuleWithConfig(t, config)
}

