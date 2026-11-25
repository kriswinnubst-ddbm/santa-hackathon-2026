-- TODO(elf-jingle): free text + broken json still go to manual review, make this smarter
with l as (
    select * from {{ ref('stg_letters') }}
)
select
    letter_id,
    received_at,
    channel,
    upper(left(coalesce(
        payload_json:child:country::string,
        payload_json:country_code::string,
        payload_json:land::string,
        postal_country), 2)) as country_guess,
    coalesce(
        payload_json:child:id::string,
        payload_json:payload:body:from:ref::string) as child_id,
    coalesce(
        payload_json:child:name::string,
        payload_json:kid_name::string,
        payload_json:naam::string,
        payload_json:Name::string,
        payload_json:prenom::string,
        payload_json:nombre::string,
        payload_json:from::string,
        payload_json:payload:body:from:first::string,
        payload_json:name::string) as child_name,
    case
        when payload_json:wishes is not null and is_array(payload_json:wishes) then 'structured_json'
        when payload_json:wishlist is not null then 'flat_json'
        when payload_json:payload is not null then 'nested_json'
        when is_valid_json then 'localised_json'
        when raw_payload ilike 'dear%' or raw_payload ilike 'lie%' or raw_payload ilike 'cher%' or raw_payload ilike 'quer%' or raw_payload ilike 'caro%' then 'free_text_nlp'
        else 'manual_elf_review'
    end as parse_method,
    raw_payload
from l
