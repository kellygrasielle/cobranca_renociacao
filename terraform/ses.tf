resource "aws_ses_template" "pagamento-pendente" {
  name    = "pagamento-pendente"
  subject = "Pendencia financeira com ITAU"
  html    = "<h1>Hello {{name}},</h1><p>Pendencia financeira com ITAU.</p>"
  text    = "Hello {{name}},\r\nYPendencia financeira com ITAU."
}

