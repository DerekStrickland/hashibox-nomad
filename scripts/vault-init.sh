

bolt command run "VAULT_ADDR=http://192.168.60.30:8200 vault operator init" --targets=192.168.60.10 --run-as root --stream > .secrets/vault-init.json

bolt command run "curl -i -X POST -H ""Content-Type: application/json"" --data '{\"secret_shares\": 1,\"secret_threshold\": 1}' http://192.168.60.30:8200/v1/sys/init" --targets=192.168.60.10 --run-as root  --stream > .secrets/vault-init.json

