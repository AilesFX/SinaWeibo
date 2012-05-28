package SinaWeiboExample;

use JSON;
use Data::Dumper;
use HTTP::Request::Common;
use LWP::UserAgent;
use HTTP::Request;
use Net::OAuth2::Client;
use namespace::autoclean;
use HTTP::Headers;

sub app_key {'********'};
sub app_secret {'************'};
sub callback_url {'http://host/callback'};
sub site {'https://api.weibo.com'};
sub access_token_url {'https://api.weibo.com/oauth2/access_token'};
sub authorize_url {'https://api.weibo.com/oauth2/authorize'};
sub oauth2_path {'https://api.weibo.com/oauth2/'};


sub weibo_index{
    return $self->render('weibo_index.html');
}

sub weibo_check{
    my $client = &client;
    warn $client->authorize_url;
    print"Location:".$client->authorize_url;
    return 0;  
}

sub client {
    Net::OAuth2::Client->new (
        app_key(),
        app_secret(),
        user_agent => LWP::UserAgent->new(ssl_opts => {SSL_verify_mode => '0x01'}),
        site => site(),
        authorize_url=>authorize_url(),
        access_token_url=>access_token_url(),
        access_token_method => 'POST',
    )->web_server(redirect_uri => callback_url());
}
# this is your callback logic 
sub weibo{
    my $client = &client;
    my $access_token = $client->get_access_token(param('code'));
    #access token验证通过后，真正的对api发起请求，列表见http://open.weibo.com/wiki/API文档_V2
    #请求方法有get/post/delete等，见Net::OAuth2::AccessToken模块。
    
    my $header = HTTP::Headers->new(
           Content_Type => 'application/x-www-form-urlencoded',
    );
    #高级接口，需要权限，可使用简单的接口测试
    my $response = $access_token->post('/2/statuses/upload_url_text.json',$header,'status=third test&url=http://t0.gstatic.com/images?q=tbn:ANd9GcQpBCSLYi5mojII1qRV77U-bb5igcqrxJw1k6W4zgULc5OX_j7Ldw');
    warn Dumper($response);
}

