package test

import (
	"fmt"
	"testing"

	common "github.com/cititerraform/common"
	"github.com/stretchr/testify/assert"
)

func TestCompleteWorkspaceModule(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("complete-ws")

	catalogName := defaults.CatalogName

	config := common.ModuleTestConfig{
		ModuleName:      "complete-workspace",
		TestDescription: "Validates complete workspace module inputs (parameter-only, requires provider aliases for apply)",
		RequiredVars: map[string]interface{}{
			"databricks_account_id": defaults.AccountID,
			"workspace_name":        uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"aws_region":                   defaults.AWSRegion,
			"enable_cmk":                   true,
			"create_metastore":             true,
			"create_default_catalog":       true,
			"configure_workspace_security": true,
			"create_cluster_policy":        true,
			"create_admin_group":           true,
			"default_catalog_name":         catalogName,
			"cluster_policy_name":          "secure-policy",
			"admin_group_name":             "admins",
			"force_destroy":                true,
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateOptionalInputs", func(t *testing.T) {
		assert.Equal(t, defaults.AccountID, opts.Vars["databricks_account_id"])
		assert.Equal(t, defaults.AWSRegion, opts.Vars["aws_region"])
		assert.Equal(t, true, opts.Vars["enable_cmk"])
		assert.Equal(t, true, opts.Vars["create_metastore"])
		assert.Equal(t, true, opts.Vars["create_default_catalog"])
		t.Log("All optional inputs validated")
	})
}

func TestCompleteWorkspaceModuleMinimal(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("minimal-ws")

	config := common.ModuleTestConfig{
		ModuleName:      "complete-workspace",
		TestDescription: "Validates minimal complete workspace inputs",
		RequiredVars: map[string]interface{}{
			"databricks_account_id": defaults.AccountID,
			"workspace_name":        uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"aws_region":       defaults.AWSRegion,
			"enable_cmk":       false,
			"create_metastore": false,
			"force_destroy":    true,
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateMinimalConfig", func(t *testing.T) {
		assert.Equal(t, false, opts.Vars["enable_cmk"])
		assert.Equal(t, false, opts.Vars["create_metastore"])
		t.Log("Minimal configuration validated")
	})
}

func TestCompleteWorkspaceModuleWithIPRestriction(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("secure-ws")

	config := common.ModuleTestConfig{
		ModuleName:      "complete-workspace",
		TestDescription: "Validates workspace with IP restriction inputs",
		RequiredVars: map[string]interface{}{
			"databricks_account_id": defaults.AccountID,
			"workspace_name":        uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"aws_region":            defaults.AWSRegion,
			"enable_cmk":            true,
			"allowed_ip_addresses":  []string{"0.0.0.0/0"},
			"create_ip_access_list": true,
			"force_destroy":         true,
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateIPRestrictions", func(t *testing.T) {
		assert.Equal(t, true, opts.Vars["create_ip_access_list"])
		ips := opts.Vars["allowed_ip_addresses"].([]string)
		assert.Contains(t, ips, "0.0.0.0/0")
		t.Log("IP restriction configuration validated")
	})
}

func TestMWSCredentialsModule(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("mws-creds")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-credentials",
		ModulePath:      "../modules/mws-credentials",
		TestDescription: "Tests Databricks MWS credentials module",
		RequiredVars: map[string]interface{}{
			"account_id":       defaults.AccountID,
			"credentials_name": fmt.Sprintf("%s-credentials", uniqueID),
			"role_arn":         defaults.CrossAccountARN,
		},
		ExpectedOutputs: []string{
			"id",
			"credentials_id",
			"credentials_name",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing MWS credentials module: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestMWSStorageConfigurationModule(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("mws-storage")

	config := common.ModuleTestConfig{
		ModuleName:      "mws-storage-configuration",
		ModulePath:      "../modules/mws-storage-configuration",
		TestDescription: "Tests Databricks MWS storage configuration module",
		RequiredVars: map[string]interface{}{
			"account_id":                 defaults.AccountID,
			"storage_configuration_name": fmt.Sprintf("%s-storage-config", uniqueID),
			"bucket_name":                defaults.S3BucketName,
		},
		ExpectedOutputs: []string{
			"id",
			"storage_configuration_id",
			"storage_configuration_name",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing MWS storage configuration module: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestMWSNetworksModule(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("mws-network")

	subnetIDs := defaults.SubnetIDs
	if subnetIDs == nil {
		subnetIDs = []string{"subnet-placeholder1", "subnet-placeholder2"}
	}

	config := common.ModuleTestConfig{
		ModuleName:      "mws-networks",
		ModulePath:      "../modules/mws-networks",
		TestDescription: "Tests Databricks MWS networks module",
		RequiredVars: map[string]interface{}{
			"account_id":          defaults.AccountID,
			"network_name":       fmt.Sprintf("%s-network", uniqueID),
			"vpc_id":             defaults.VPCID,
			"subnet_ids":         subnetIDs,
			"security_group_ids": []string{defaults.SecurityGroupID},
			"vpc_endpoints": map[string]interface{}{
				"dataplane_relay": []string{},
				"rest_api":        []string{},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"network_id",
			"network_name",
			"vpc_id",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing MWS networks module: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestWorkspaceModule(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("workspace")

	config := common.ModuleTestConfig{
		ModuleName:      "workspace",
		ModulePath:      "../modules/workspace",
		TestDescription: "Validates workspace module inputs (parameter-only)",
		RequiredVars: map[string]interface{}{
			"workspace_name":           fmt.Sprintf("%s-ws", uniqueID),
			"account_id":              defaults.AccountID,
			"aws_region":              defaults.AWSRegion,
			"credentials_id":          common.GetEnvOrDefault("DATABRICKS_CREDENTIALS_ID", "placeholder-cred-id"),
			"storage_configuration_id": common.GetEnvOrDefault("DATABRICKS_STORAGE_CONFIG_ID", "placeholder-storage-id"),
		},
		OptionalVars: map[string]interface{}{
			"network_id":   common.GetEnvOrDefault("DATABRICKS_NETWORK_ID", ""),
			"pricing_tier": "ENTERPRISE",
			"custom_tags": map[string]string{
				"Environment": "test",
				"CreatedBy":   "terratest",
			},
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateWorkspaceConfig", func(t *testing.T) {
		assert.Equal(t, "ENTERPRISE", opts.Vars["pricing_tier"])
		tags := opts.Vars["custom_tags"].(map[string]string)
		assert.Equal(t, "test", tags["Environment"])
		t.Log("Workspace configuration validated")
	})
}

func TestMetastoreModule(t *testing.T) {
	defaults := common.GetTestDefaults()

	uniqueID := common.GenerateUniqueTestID("metastore")

	config := common.ModuleTestConfig{
		ModuleName:      "metastore",
		ModulePath:      "../modules/metastore",
		TestDescription: "Tests Databricks Unity Catalog metastore module",
		RequiredVars: map[string]interface{}{
			"name":         fmt.Sprintf("%s-metastore", uniqueID),
			"storage_root": fmt.Sprintf("s3://%s/metastore", defaults.S3BucketName),
			"region":       defaults.AWSRegion,
		},
		OptionalVars: map[string]interface{}{
			"owner":               "account users",
			"force_destroy":       true,
			"delta_sharing_scope": "INTERNAL_AND_EXTERNAL",
		},
		ExpectedOutputs: []string{
			"id",
			"metastore_id",
			"name",
			"storage_root",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing metastore module: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestCatalogModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("catalog")

	config := common.ModuleTestConfig{
		ModuleName:      "catalog",
		ModulePath:      "../modules/catalog",
		TestDescription: "Validates catalog module inputs (parameter-only)",
		RequiredVars: map[string]interface{}{
			"name": fmt.Sprintf("%s-catalog", uniqueID),
		},
		OptionalVars: map[string]interface{}{
			"comment": "Test catalog created by terratest for complete-workspace",
			"properties": map[string]string{
				"environment": "test",
				"purpose":     "terratest-complete-workspace",
			},
			"isolation_mode": "ISOLATED",
			"force_destroy":  true,
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateCatalogConfig", func(t *testing.T) {
		assert.Equal(t, "ISOLATED", opts.Vars["isolation_mode"])
		assert.Equal(t, true, opts.Vars["force_destroy"])
		t.Log("Catalog configuration validated")
	})
}

func TestCatalogModuleMinimal(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("catalog-min")

	config := common.ModuleTestConfig{
		ModuleName:      "catalog",
		ModulePath:      "../modules/catalog",
		TestDescription: "Validates catalog module with minimal config",
		RequiredVars: map[string]interface{}{
			"name": fmt.Sprintf("%s-catalog", uniqueID),
		},
		OptionalVars: map[string]interface{}{
			"force_destroy": true,
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateMinimalConfig", func(t *testing.T) {
		assert.Equal(t, true, opts.Vars["force_destroy"])
		t.Log("Minimal catalog configuration validated")
	})
}

func TestWorkspaceConfModule(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "workspace-conf",
		ModulePath:      "../modules/workspace-conf",
		TestDescription: "Tests Databricks workspace security configuration module",
		RequiredVars:    map[string]interface{}{},
		OptionalVars: map[string]interface{}{
			"enable_results_downloading":        false,
			"enable_notebook_table_clipboard":   false,
			"enable_verbose_audit_logs":         true,
			"enable_dbfs_file_browser":          false,
			"enable_export_notebook":            false,
			"enforce_user_isolation":            true,
			"store_results_in_customer_account": true,
			"enable_upload_data_uis":            false,
			"disable_legacy_access":             true,
			"disable_legacy_dbfs":               true,
		},
		ExpectedOutputs: []string{
			"workspace_conf_id",
			"applied_settings",
			"legacy_access_disabled",
			"legacy_dbfs_disabled",
		},
		SkipDestroy: false,
	}

	t.Log("Testing workspace-conf module with SRA security settings")
	common.TestModuleWithConfig(t, config)
}

func TestWorkspaceConfModuleRelaxed(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "workspace-conf",
		ModulePath:      "../modules/workspace-conf",
		TestDescription: "Tests workspace-conf module with relaxed settings for dev environments",
		RequiredVars:    map[string]interface{}{},
		OptionalVars: map[string]interface{}{
			"enable_results_downloading":        true,
			"enable_notebook_table_clipboard":   true,
			"enable_verbose_audit_logs":         true,
			"enable_dbfs_file_browser":          true,
			"enable_export_notebook":            true,
			"enforce_user_isolation":            false,
			"store_results_in_customer_account": false,
			"enable_upload_data_uis":            true,
			"disable_legacy_access":             false,
			"disable_legacy_dbfs":               false,
		},
		ExpectedOutputs: []string{
			"workspace_conf_id",
			"applied_settings",
		},
		SkipDestroy: false,
	}

	t.Log("Testing workspace-conf module with relaxed dev settings")
	common.TestModuleWithConfig(t, config)
}

func TestClusterPolicyModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("policy")

	config := common.ModuleTestConfig{
		ModuleName:      "cluster-policy",
		ModulePath:      "../modules/cluster-policy",
		TestDescription: "Tests Databricks cluster policy module",
		RequiredVars: map[string]interface{}{
			"name": fmt.Sprintf("%s-secure-policy", uniqueID),
		},
		OptionalVars: map[string]interface{}{
			"description":           "Secure cluster policy created by terratest",
			"max_clusters_per_user": 5,
			"definition": `{
				"spark_version": {
					"type": "regex",
					"pattern": "^[0-9]+\\.[0-9]+\\.x-.*"
				},
				"data_security_mode": {
					"type": "fixed",
					"value": "USER_ISOLATION"
				},
				"enable_local_disk_encryption": {
					"type": "fixed",
					"value": true
				},
				"autotermination_minutes": {
					"type": "range",
					"minValue": 10,
					"maxValue": 10080
				}
			}`,
		},
		ExpectedOutputs: []string{
			"id",
			"policy_id",
			"name",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing cluster policy module: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestClusterPolicyModuleMinimal(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("policy-min")

	config := common.ModuleTestConfig{
		ModuleName:      "cluster-policy",
		ModulePath:      "../modules/cluster-policy",
		TestDescription: "Validates cluster policy module with minimal config",
		RequiredVars: map[string]interface{}{
			"name": fmt.Sprintf("%s-minimal-policy", uniqueID),
		},
		OptionalVars: map[string]interface{}{},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateMinimalConfig", func(t *testing.T) {
		assert.Contains(t, opts.Vars["name"], "minimal-policy")
		t.Log("Minimal cluster policy configuration validated")
	})
}

func TestIPAccessListModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("ip-acl")

	config := common.ModuleTestConfig{
		ModuleName:      "ip-access-list",
		ModulePath:      "../modules/ip-access-list",
		TestDescription: "Tests Databricks IP access list module",
		RequiredVars: map[string]interface{}{
			"list_type": "ALLOW",
			"label":     fmt.Sprintf("%s-corporate-network", uniqueID),
			"ip_addresses": []string{
				"10.0.0.0/8",
				"172.16.0.0/12",
				"192.168.0.0/16",
			},
		},
		OptionalVars: map[string]interface{}{
			"enabled": true,
		},
		ExpectedOutputs: []string{
			"id",
			"label",
			"list_type",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing IP access list module: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestIPAccessListModuleBlock(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("ip-block")

	config := common.ModuleTestConfig{
		ModuleName:      "ip-access-list",
		ModulePath:      "../modules/ip-access-list",
		TestDescription: "Tests IP access list module with BLOCK type",
		RequiredVars: map[string]interface{}{
			"list_type":    "BLOCK",
			"label":        fmt.Sprintf("%s-blocked-ips", uniqueID),
			"ip_addresses": []string{"203.0.113.0/24"},
		},
		OptionalVars: map[string]interface{}{
			"enabled": true,
		},
		ExpectedOutputs: []string{
			"id",
			"label",
			"list_type",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing IP access list module with BLOCK: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestGroupModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("group")

	config := common.ModuleTestConfig{
		ModuleName:      "group",
		ModulePath:      "../modules/group",
		TestDescription: "Tests Databricks group module",
		RequiredVars: map[string]interface{}{
			"display_name": fmt.Sprintf("%s-workspace-admins", uniqueID),
		},
		OptionalVars: map[string]interface{}{
			"allow_cluster_create":       true,
			"allow_instance_pool_create": true,
			"databricks_sql_access":      true,
			"workspace_access":           true,
			"force":                      true,
		},
		ExpectedOutputs: []string{
			"id",
			"display_name",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing group module: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}

func TestGroupModuleMinimal(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("group-min")

	config := common.ModuleTestConfig{
		ModuleName:      "group",
		ModulePath:      "../modules/group",
		TestDescription: "Tests group module with minimal permissions",
		RequiredVars: map[string]interface{}{
			"display_name": fmt.Sprintf("%s-readonly-group", uniqueID),
		},
		OptionalVars: map[string]interface{}{
			"allow_cluster_create":       false,
			"allow_instance_pool_create": false,
			"databricks_sql_access":      false,
			"workspace_access":           true,
			"force":                      true,
		},
		ExpectedOutputs: []string{
			"id",
			"display_name",
		},
		SkipDestroy: false,
	}

	t.Logf("Testing group module with minimal permissions: %s", uniqueID)
	common.TestModuleWithConfig(t, config)
}
