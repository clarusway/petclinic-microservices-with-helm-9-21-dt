echo 'Deploying App on Kubernetes'
sh "envsubst < k8s/petclinic_chart/values-template.yaml > k8s/petclinic_chart/values.yaml"
sh "sed -i s/HELM_VERSION/${BUILD_NUMBER}/ k8s/petclinic_chart/Chartyaml"
sh "helm repo add stable-petclinic s3://petclinic-helm-charts/stablemyapp/"
sh "helm package k8s/petclinic_chart"
sh "helm s3 push petclinic_chart-${BUILD_NUMBER}.tgz stable-petclinic"
sh "envsubst < ansible/playbooks/qa-petclinic-deploy-template >ansible/playbooks/qa-petclinic-deploy.yaml"
sh "sleep 60"    
sh "ansible-playbook -i ./ansible/inventory/qa_stack_dynamic_inventory_aws_ec2.yaml ./ansible/playbooks/qa-petclinic-deploy.yaml"