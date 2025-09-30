# build + run in the official Swift image (easy & reliable)
FROM swift:5.9-jammy

WORKDIR /app
COPY . .

# fetch deps & build a release binary
RUN swift build -c release

ENV PORT=8080
EXPOSE 8080
# launch your Vapor app
CMD [".build/release/App","serve","--env","production","--hostname","0.0.0.0","--port","8080"]
