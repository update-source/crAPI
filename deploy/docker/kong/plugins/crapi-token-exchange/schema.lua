return {
  name = "crapi-token-exchange",
  fields = {
    { config = {
        type = "record",
        fields = {
          { crapi_login_url = { type = "string", required = true, default = "https://crapi-identity:8080/identity/api/auth/login" } },
          { service_email = { type = "string", required = true } },
          { service_password = { type = "string", required = true } },
          { token_ttl = { type = "number", default = 3000 } },
        },
    }, },
  },
}