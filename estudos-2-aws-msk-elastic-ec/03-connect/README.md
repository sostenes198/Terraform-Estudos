```bash
aws logs filter-log-events \
  --log-group-name "/aws/msk-connect/poc" \
  --filter-pattern "ERROR || Exception || java.lang" \
  --region us-east-1 --profile poc-mks
```

```bash
aws kafkaconnect list-connectors --profile poc-mks
```