#!/bin/bash

# Função para logar mensagens
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# 1. Formatando NameNode se necessário
if [ ! -f /hadoop/dfs/name/current/VERSION ]; then
  log "Formatting NameNode..."
  hdfs namenode -format -force
fi

# 2. Iniciando NameNode em segundo plano
log "Starting NameNode..."
hdfs namenode &

# 3. Esperando NameNode estar responsivo
log "Waiting for NameNode (9870) to be up..."
until curl -s http://localhost:9870 > /dev/null; do
  sleep 2
done
log "NameNode UI is up."

# 4. Esperando DataNodes se conectarem
log "Waiting for DataNodes to connect..."
MIN_DATANODES=2
ACTUAL_DATANODES=0
while [ $ACTUAL_DATANODES -lt $MIN_DATANODES ]; do
  # Silencia o stderr para evitar spam de "Call to localhost:8020 failed" enquanto o NameNode está inicializando
  ACTUAL_DATANODES=$(hdfs dfsadmin -report 2>/dev/null | grep "Live datanodes" | awk '{print $3}' | tr -d '()')
  ACTUAL_DATANODES=${ACTUAL_DATANODES:-0}
  
  if [ $ACTUAL_DATANODES -lt $MIN_DATANODES ]; then
    log "Live DataNodes: $ACTUAL_DATANODES (Waiting for $MIN_DATANODES...)"
    sleep 5
  fi
done
log "Minimum DataNodes reached ($ACTUAL_DATANODES)."

# 5. Sair do Modo de Segurança
log "Attempting to leave Safe Mode..."
hdfs dfsadmin -safemode leave
log "Safe Mode left."

# 6. Setup Diretorios HDFS
log "Setting up HDFS directories..."
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -mkdir -p /apps/tez
hdfs dfs -chmod -R 777 /tmp
hdfs dfs -chmod -R 777 /tmp/hive
hdfs dfs -chmod -R 777 /user/hive
hdfs dfs -chmod -R 777 /apps/tez
log "HDFS setup complete."

# 7. Espera o processo do NameNode terminar (o que não deve acontecer a menos que seja parado)
wait
