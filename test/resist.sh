#!/bin/bash

# Fork in background se non già in background
if [[ $1 != "--child" ]]; then
    "$0" --child &
    echo "Started resistant process, PID: $!"
    exit 0
fi

# Codice del processo resistente
sigterm_received=0

handle_term() {
    echo "PID $$ received SIGTERM, will exit in 5 seconds..."
    sigterm_received=1
}

trap 'handle_term' TERM

echo "Child process running, PID: $$"

start_time=$SECONDS
while true; do
    sleep 0.5

    # Se SIGTERM ricevuto e passati 5 secondi, termina
    if [[ $sigterm_received -eq 1 ]]; then
        elapsed=$((SECONDS - start_time))
        if [[ $elapsed -ge 5 ]]; then
            echo "PID $$ exiting after 5 seconds delay"
            exit 0
        fi
    else
        # Reset timer se SIGTERM non ancora ricevuto
        start_time=$SECONDS
    fi
done

