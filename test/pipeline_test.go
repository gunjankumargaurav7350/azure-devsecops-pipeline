package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAzureDevSecOpsPipelineInfrastructure(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../terraform",
		Vars: map[string]interface{}{
			"environment": "test",
			"location":    "eastus",
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndPlan(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	vnetID := terraform.Output(t, terraformOptions, "hub_vnet_id")
	assert.NotEmpty(t, vnetID)

	subnets := terraform.OutputMap(t, terraformOptions, "subnet_ids")
	assert.Contains(t, subnets, "snet-workload")
}
